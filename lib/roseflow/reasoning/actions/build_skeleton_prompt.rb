# frozen_string_literal: true

require "roseflow/reasoning/prompts/skeleton_system_prompt"

module Roseflow
  module Reasoning
    module Actions
      class BuildSkeletonPrompt
        extend Roseflow::Action

        expects :prompt, :model

        executed do |ctx|
          ctx[:messages] = [build_system_message, build_user_message(ctx.prompt)]
        end

        def self.build_system_message
          Roseflow::Chat::SystemMessage.new(role: "system", content: Prompts::SkeletonSystemPrompt.new.call)
        end

        def self.build_user_message(prompt)
          Roseflow::Chat::UserMessage.new(role: "user", content: prompt)
        end
      end
    end
  end
end
