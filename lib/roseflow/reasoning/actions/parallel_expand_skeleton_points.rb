# frozen_string_literal: true

require "async"
require "async/barrier"

require "roseflow/reasoning/actions/expand_single_skeleton_point"

module Roseflow
  module Reasoning
    module Actions
      class ParallelExpandSkeletonPoints
        extend Roseflow::Action

        expects :points

        executed do |ctx|
          ctx[:expanded_points] = {} unless ctx[:expanded_points].is_a?(Hash)
          barrier = Async::Barrier.new

          Sync do
            ctx[:points].map do |point|
              barrier.async do
                action = Actions::ExpandSingleSkeletonPoint.execute(ctx.merge(point: point))
                ctx[:expanded_points][point.order] = action[:expanded_points][point.order]
              end
            end.map(&:wait)
          ensure
            barrier.stop
          end
        end
      end
    end
  end
end
