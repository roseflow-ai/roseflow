# frozen_string_literal: true

require "roseflow/interaction"
require "roseflow/reasoning/actions/build_skeleton_prompt"
require "roseflow/reasoning/actions/generate_skeleton"
require "roseflow/reasoning/interactions/expand_skeleton_points"
require "roseflow/reasoning/actions/generate_final_answer"

module Roseflow
  module Reasoning
    class SkeletonOfThought
      extend Roseflow::Interaction

      def self.call(context)
        with(context).reduce(self.actions)
      end

      def self.actions
        [
          Actions::BuildSkeletonPrompt,
          Actions::GenerateSkeleton,
          Interactions::ExpandSkeletonPoints,
          Actions::GenerateFinalAnswer,
        ]
      end
    end
  end
end
