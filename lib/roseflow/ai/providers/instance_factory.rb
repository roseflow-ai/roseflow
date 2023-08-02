# frozen_string_literal: true

require_relative "./openai_adapter"
require_relative "./openrouter_adapter"

module Roseflow
  module AI
    module Providers
      class InstanceFactory
        def self.create(config)
          begin
            adapter = Providers.const_get(config.fetch(:adapter_class))
            klass = Object.const_get("#{config.fetch(:namespace)}::Provider")
            adapter.new(klass.new)
          rescue => exception
            raise NotImplementedError, "Adapter for provider #{config.fetch(:name)} not implemented"
          end
        end
      end
    end
  end
end
