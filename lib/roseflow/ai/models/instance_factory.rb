# frozen_string_literal: true

module Roseflow
  module AI
    module Models
      class InstanceFactory
        def self.create(name, provider)
          provider_model = provider.models.find(name)
          raise ModelInstanceNotFoundError, "Instance for #{name} not found" if provider_model.nil?

          begin
            provider_config = PROVIDER_GEMS.find { |gem, settings| settings[:name] == provider.name.to_sym }.last
            adapter_class = Models.const_get(provider_config.fetch(:adapter_class))
            adapter_class.new(provider_model)
          rescue => exception
            raise NotImplementedError, "Model adapter for provider '#{provider.name}' not implemented"
          end
        end
      end
    end
  end
end
