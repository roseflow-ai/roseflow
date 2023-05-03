# frozen_string_literal: true

require "ulid"
require "roseflow/vector_stores/hnsw_pb"

module Roseflow
  module VectorStores
    UnsupportedSimilarityMetricError = Class.new(StandardError)

    class HNSWMemoryStore < Base
      PROBABILITY_FACTORS = [
        0.5,
        1 / Math::E
      ].freeze

      def initialize(similarity_metric, dimensions, m, ef)
        @similarity_metric = similarity_metric
        @dimensions = dimensions
        @m = m
        @ef = ef
        @max_level = 0
        @entrypoint = nil
        @nodes = {}
      end

      delegate :size, to: :@nodes

      attr_accessor :nodes

      def add_node(node_id, vector)
        level = get_random_level
        node = HNSWNode.new(node_id, vector, level, @m)

        if @entrypoint.nil?
          @entrypoint = node
          return @nodes[node_id] = node
        end

        update_max_level(level)
        current_node = search_level(vector, @entrypoint, @max_level)

        @max_level.downto(0) do |i|
          if i <= level
            neighbors = find_neighbors(current_node, vector, i)
            update_neighbors(node, neighbors, vector, i)
          end

          current_node = search_level(vector, @entrypoint, i - 1) if i > 0
        end

        @nodes[node_id] = node
      end

      def delete_node(node_id)
        @nodes.delete(node_id)
      end

      def find(node_id)
        @nodes[node_id]
      end

      def serialize
        graph = HNSWGraph.new(
          entrypoint_id: @entrypoint.id,
          max_level: @max_level,
          similarity_metric: @similarity_metric,
          dimensions: @dimensions,
          m: @m,
          ef: @ef,
          nodes: @nodes.values.map do |node|
            HNSWGraphNode.new(
              id: node.id,
              vector: node.vector,
              level: node.level,
              neighbors: node.neighbors.flatten.compact.map(&:id)
            )
          end
        )

        graph.to_proto
      end

      def self.deserialize(serialized_data)
        graph = HNSWGraph.decode(serialized_data)

        hnsw = new(graph.similarity_metric, graph.dimensions, graph.m, graph.ef)

        # Create nodes
        graph.nodes.each do |node|
          hnsw.nodes[node.id] = HNSWNode.new(node.id, node.vector, node.level, graph.m)
        end

        # Set neighbors
        graph.nodes.each do |node|
          neighbors = node.neighbors.each_slice(graph.m).to_a
          neighbors.each_with_index do |neighbor_ids, level|
            neighbor_ids.each_with_index do |neighbor_id, index|
              hnsw.nodes[node.id].neighbors[level][index] = hnsw.nodes[neighbor_id] if hnsw.nodes.key?(neighbor_id)
            end
          end
        end

        hnsw.instance_variable_set(:@entrypoint, hnsw.nodes[graph.entrypoint_id])
        hnsw.instance_variable_set(:@max_level, graph.max_level)

        hnsw
      end

      def find_neighbors(node, query, level)
        search_knn(node, query, @m, level)
      end

      def update_neighbors(node, neighbors, query, level)
        node.neighbors[level] = neighbors[0, @m]

        neighbors.each do |neighbor|
          n_distance = distance(neighbor.vector, query)
          furthest_neighbor_index = neighbor.neighbors[level].index { |n| n.nil? || n_distance < distance(neighbor.vector, n.vector) }
          next unless furthest_neighbor_index

          neighbor.neighbors[level].insert(furthest_neighbor_index, node)
          neighbor.neighbors[level].pop if neighbor.neighbors[level].size > @m
        end
      end

      def update_max_level(level)
        @max_level = level if level > @max_level
      end

      def nearest_neighbors(query, k)
        return [] unless @entrypoint
        entry_point = @entrypoint
        (0..@max_level).reverse_each do |level|
          entry_point = search_level(query, entry_point, level)
        end
        search_knn(entry_point, query, k, 0)
      end

      def search_level(query, entry_point, level)
        current = entry_point
        best_distance = distance(query, current.vector)

        loop do
          closest_neighbor, closest_distance = find_closest_neighbor(query, current.neighbors[level])

          if closest_neighbor && closest_distance < best_distance
            best_distance = closest_distance
            current = closest_neighbor
          else
            break
          end
        end

        current
      end

      def find_closest_neighbor(query, neighbors)
        closest_neighbor = nil
        closest_distance = Float::INFINITY

        neighbors.each do |neighbor|
          next unless neighbor
          distance = distance(query, neighbor.vector)
          if distance < closest_distance
            closest_distance = distance
            closest_neighbor = neighbor
          end
        end

        [closest_neighbor, closest_distance]
      end

      def search_knn(entry_point, query, k, level)
        visited = Set.new
        candidates = Set.new([entry_point])
        result = []

        while candidates.size > 0
          closest = candidates.min_by { |c| distance(query, c.vector) }
          candidates.delete(closest)
          visited.add(closest.id)

          if result.size < k
            result.push(closest)
          else
            furthest_result = result.max_by { |r| distance(query, r.vector) }

            closest_distance = distance(query, closest.vector)
            furthest_result_distance = distance(query, furthest_result.vector)

            if closest_distance < furthest_result_distance
              result.delete(furthest_result)
              result.push(closest)
            else
              break
            end
          end

          closest.neighbors[level].each do |neighbor|
            next unless neighbor
            next if visited.include?(neighbor.id)
            candidates.add(neighbor)
          end
        end

        result
      end

      def distance(from, to)
        case @similarity_metric.to_sym
        when :euclidean
          euclidean_distance(from, to)
        when :cosine
          cosine_distance(from, to)
        else
          raise UnsupportedSimilarityMetricError, "Similarity metric #{@similarity_metric} is not supported"
        end
      end

      def euclidean_distance(from, to)
        e_distance = 0
        from.each_with_index do |value, index|
          e_distance += (value - to[index])**2
        end

        Math.sqrt(e_distance)
      end

      def cosine_distance(from, to)
        dot_product = 0
        norm_from = 0
        norm_to = 0

        from.each_with_index do |value, index|
          dot_product += value * to[index]
          norm_from += value**2
          norm_to += to[index]**2
        end

        1 - (dot_product / (Math.sqrt(norm_from) * Math.sqrt(norm_to)))
      end

      def get_random_level
        level = 0
        while rand < PROBABILITY_FACTORS[0] && level < @max_level
          level += 1
        end
        level
      end

      class HNSWNode
        attr_reader :id, :vector
        attr_accessor :level, :neighbors

        def initialize(id, vector, level, m)
          @id = id
          @vector = vector
          @level = level
          @neighbors = Array.new(level + 1) { Array.new(m) }
        end
      end

      class BoundedPriorityQueue
        def initialize(max_size)
          @max_size = max_size
          @queue = PriorityQueue.new
        end

        def size
          @queue.size
        end

        def push(item)
          if size < @max_size
            @queue.push(item)
          elsif item[0] < @queue.peek[0]
            @queue.pop
            @queue.push(item)
          end
        end

        def peek
          @queue.peek
        end

        def to_a
          @queue.to_a
        end
      end

      class PriorityQueue
        def initialize
          @elements = []
        end

        def size
          @elements.size
        end

        def empty?
          @elements.empty?
        end

        def push(item)
          @elements << item
          shift_up(@elements.size - 1)
        end

        def pop
          return if empty?

          swap(0, @elements.size - 1)
          element = @elements.pop
          shift_down(0)
          element
        end

        def peek
          @elements.first
        end

        def to_a
          @elements.dup
        end

        private

        def swap(i, j)
          @elements[i], @elements[j] = @elements[j], @elements[i]
        end

        def shift_up(i)
          parent = (i - 1) / 2
          return if i <= 0 || @elements[parent][0] <= @elements[i][0]

          swap(i, parent)
          shift_up(parent)
        end

        def shift_down(i)
          left_child = 2 * i + 1
          right_child = 2 * i + 2

          min = i
          min = left_child if left_child < size && @elements[left_child][0] < @elements[min][0]
          min = right_child if right_child < size && @elements[right_child][0] < @elements[min][0]

          return if min == i

          swap(i, min)
          shift_down(min)
        end
      end
    end
  end
end
