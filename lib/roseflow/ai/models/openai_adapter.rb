# frozen_string_literal: true

require "roseflow/ai/model_interface"
require "roseflow/ai/models/base_adapter"

module Roseflow
  module AI
    module Models
      class OpenAIAdapter < BaseAdapter
        include ModelInterface

        def call(operation, options, &block)
          @model.call(operation, options, &block)
        end

        def chat(options, &block)
          @model.chat(options.delete(:messages), options, &block)
        end

        def embed(options)
          @model.embed(options)
        end

        def operations
          @model.operations
        end
      end
    end
  end
end