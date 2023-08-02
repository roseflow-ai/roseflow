# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Actions
      class GenerateSkeleton
        extend Roseflow::Action

        expects :model, :messages

        executed do |ctx|
          ctx[:skeleton] = ctx.model.chat(messages: ctx.messages, max_tokens: 2048, temperature: 1.0).response.to_s
        end
      end
    end
  end
end
