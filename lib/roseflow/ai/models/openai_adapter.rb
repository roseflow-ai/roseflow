# frozen_string_literal: true

require "roseflow/ai/model_interface"
require "roseflow/ai/models/base_adapter"

module Roseflow
  module AI
    module Models
      class OpenAIAdapter < BaseAdapter
        include ModelInterface

        def configuration
          @configuration ||= Models::Configuration.new(name: @model.name)
        end

        alias_method :config, :configuration

        def configuration=(config)
          @configuration = config
        end

        def call(operation, options, &block)
          @model.call(operation, options, &block)
        end

        def chat(options, &block)
          response = @model.chat(options.delete(:messages), options, &block)
          publish_api_usage(response.usage) if @configuration&.instrumentation
          response
        end

        def embed(options)
          @model.embed(options)
        end

        def operations
          @model.operations
        end

        private

        def publish_api_usage(usage)
          Registry.get(:events).publish(:api_usage_event, usage: usage.to_h)
        end
      end
    end
  end
end
