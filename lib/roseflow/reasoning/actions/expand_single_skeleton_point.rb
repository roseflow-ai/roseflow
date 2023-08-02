# frozen_string_literal: true

require "roseflow/reasoning/prompts/expand_single_skeleton_point_system_prompt"
require "roseflow/reasoning/prompts/expand_single_skeleton_point_user_prompt"
require "roseflow/reasoning/skeleton_point"

module Roseflow
  module Reasoning
    module Actions
      class ExpandSingleSkeletonPoint
        extend Roseflow::Action

        expects :point

        executed do |ctx|
          ctx[:expanded_points] = {} unless ctx[:expanded_points].is_a?(Hash)
          point = SkeletonPoint.new(ctx[:point])
          messages = [
            build_system_message(ctx[:skeleton], ctx[:prompt]),
            build_user_message(point),
          ]
          response = ctx[:model].chat(messages: messages, max_tokens: 200, temperature: 1.0).response.to_s
          ctx[:expanded_points][point.order] = SkeletonPoint.new(JSON.parse(response))
        end

        def self.build_system_message(skeleton, prompt)
          {
            role: "system",
            content: Prompts::ExpandSingleSkeletonPointSystemPrompt.new(skeleton, prompt).call,
          }
        end

        def self.build_user_message(point)
          {
            role: "user",
            content: Prompts::ExpandSingleSkeletonPointUserPrompt.new(point).call,
          }
        end
      end
    end
  end
end
