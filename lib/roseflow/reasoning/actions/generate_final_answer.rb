# frozen_string_literal: true

require "roseflow/chat/message"
require "roseflow/reasoning/prompts/final_answer_system_prompt"
require "roseflow/reasoning/prompts/final_answer_user_prompt"

module Roseflow
  module Reasoning
    module Actions
      class GenerateFinalAnswer
        extend Roseflow::Action

        expects :expanded_points

        executed do |ctx|
          messages = [
            Roseflow::Chat::SystemMessage.new(role: "system", content: Prompts::FinalAnswerSystemPrompt.new(ctx[:prompt], resolve_model_provider(ctx[:model].name)).call),
            Roseflow::Chat::UserMessage.new(role: "user", content: Prompts::FinalAnswerUserPrompt.new(ctx[:expanded_points]).call),
          ]

          ctx[:answer] = ctx[:model].chat(messages: messages, max_tokens: 2048, temperature: 1.0).response
        end

        def self.resolve_model_provider(model_name)
          case model_name
          when /anthropic/
            :anthropic
          when /gpt/
            :openai
          end
        end
      end
    end
  end
end
