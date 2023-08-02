# frozen_string_literal: true

module Roseflow
  module Actions
    module AI
      class Chat
        extend Roseflow::Action

        expects :messages
        expects :model
        expects :options, default: {}

        promises :response

        executed do |context|
          context[:response] = context.model.chat(context.options.merge(messages: context.messages))
        end
      end
    end
  end
end
