# frozen_string_literal: true

require "roseflow/interaction"
require "roseflow/reasoning/actions/add_points_to_context"
require "roseflow/reasoning/actions/expand_single_skeleton_point"
require "roseflow/reasoning/actions/parallel_expand_skeleton_points"

module Roseflow
  module Reasoning
    module Interactions
      class ExpandSkeletonPoints
        extend Roseflow::Interaction

        def self.call(context)
          with(context).reduce(self.actions)
        end

        def self.actions
          [
            Actions::AddPointsToContext,
            reduce_case(
              value: :method,
              when: {
                sequential: [
                  iterate(:points, [Actions::ExpandSingleSkeletonPoint]),
                ],
                parallel: [
                  Actions::ParallelExpandSkeletonPoints,
                ],
              },
              else: [Actions::ParallelExpandSkeletonPoints],
            ),
          ]
        end
      end
    end
  end
end
