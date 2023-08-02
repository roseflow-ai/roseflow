# frozen_string_literal: true

require "roseflow/ai/model_interface"
require "roseflow/ai/models/base_adapter"

module Roseflow
  module AI
    module Models
      class OpenRouterAdapter < OpenAIAdapter
        include ModelInterface

        def call(operation, options, &block)
          @model.call(operation, options, &block)
        end

        def chat(options, &block)
          @model.chat(options.delete(:messages), options, &block)
        end
      end
    end
  end
end
