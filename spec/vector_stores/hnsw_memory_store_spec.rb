# frozen_string_literal: true

require "spec_helper"
require "ulid"
require "roseflow/vector_stores/hnsw_memory_store"

def generate_random_vector(dimensions)
  Array.new(dimensions) { rand * 2 - 1 }
end

module Roseflow
  module VectorStores
    RSpec.describe HNSWMemoryStore do
      let(:dimensions) { 5 }
      let(:m) { 16 }
      let(:ef) { 50 }

      describe "Initialization" do
        subject { described_class.new("cosine", dimensions, m, ef) }

        it "initializes with the correct parameters" do
          expect(subject).to be_a described_class
        end
      end

      describe "Adding nodes" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }
        let(:node_id) { ULID.generate }

        it "can add a node" do
          expect(hnsw.size).to eq(0)
          expect(hnsw.add_node(node_id, generate_random_vector(dimensions))).to be_truthy
          expect(hnsw.size).to eq(1)
          expect(hnsw.nodes[node_id]).to be_a described_class::HNSWNode
        end

        it "can add multiple nodes" do
          10.times do |i|
            hnsw.add_node(ULID.generate, generate_random_vector(dimensions))
          end

          expect(hnsw.size).to eq(10)
        end
      end

      describe "Deleting nodes" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }
        let(:node_id) { ULID.generate }

        it "can delete a node" do
          hnsw.add_node(node_id, generate_random_vector(dimensions))
          expect(hnsw.size).to eq(1)
          expect(hnsw.delete_node(node_id)).to be_truthy
          expect(hnsw.size).to eq(0)
        end
      end

      describe "Retrieving nodes" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }
        let(:node_id) { ULID.generate }

        before do
          hnsw.add_node(node_id, generate_random_vector(dimensions))
        end

        it "can retrieve a node by ID" do
          expect(hnsw.find(node_id)).to be_a described_class::HNSWNode
          expect(hnsw.find(node_id).id).to eq(node_id)
        end
      end

      describe "Total size of the index" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }

        before do
          10.times { hnsw.add_node(ULID.generate, generate_random_vector(dimensions)) }
        end

        it "returns the size of the index" do
          expect(hnsw.size).to eq(10)
        end
      end

      describe "Finding nearest neighbors" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }

        before do
          10.times { hnsw.add_node(ULID.generate, generate_random_vector(dimensions)) }
        end

        it "returns the nearest neighbors" do
          k = 5
          neighbors = hnsw.nearest_neighbors(generate_random_vector(dimensions), k)
          expect(neighbors).to be_a Array
          expect(neighbors.size).to eq(k)
        end
      end

      describe "Serialization" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }

        before do
          2.times { hnsw.add_node(ULID.generate, generate_random_vector(dimensions)) }
        end

        it "serializes the index" do
          expect(hnsw.serialize).to be_a String
        end
      end

      describe "Deserialization" do
        let(:hnsw) { described_class.new("cosine", dimensions, m, ef) }

        before do
          10.times { hnsw.add_node(ULID.generate, generate_random_vector(dimensions)) }
        end

        it "deserializes correctly" do
          serialized = hnsw.serialize
          deserialized = described_class.deserialize(serialized)

          vector = generate_random_vector(dimensions)
          neighbors = hnsw.nearest_neighbors(vector, 5)
          deserialized_neighbors = deserialized.nearest_neighbors(vector, 5)

          expect(neighbors.map(&:id)).to eq(deserialized_neighbors.map(&:id))
        end
      end
    end
  end
end
