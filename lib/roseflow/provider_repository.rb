# frozen_string_literal: true

require "hashie/mash"

PROVIDER_GEMS = {
  "roseflow-openai": {
    name: :openai,
    require_name: "roseflow/openai",
    namespace: "Roseflow::OpenAI",
    adapter_class: "OpenAIAdapter",
  },
  "roseflow-openrouter": {
    name: :openrouter,
    require_name: "roseflow/open_router",
    namespace: "Roseflow::OpenRouter",
    adapter_class: "OpenRouterAdapter",
  },
}

PROVIDER_GEMS.each do |gem, settings|
  if Gem.loaded_specs.key?(gem.to_s)
    require "#{settings[:require_name]}/provider"
  end
end

module Roseflow
  class ProviderRepository
    class ProviderNotFoundError < StandardError; end
    class ProviderNotSupportedError < StandardError; end

    def initialize
      @providers = load_providers
    end

    def all
      providers
    end

    def find(name)
      result = providers.find { |provider| provider.name == name }
      raise ProviderNotFoundError, "Provider #{name} not found" if result.nil?
      result
    end

    def list
      providers.map(&:name)
    end

    def self.find(name)
      Registry.get(:providers).find(name)
    end

    def self.providers
      Registry.get(:providers).all
    end

    private

    attr_reader :providers

    def load_providers
      providers = []
      PROVIDER_GEMS.each do |gem, config|
        if Gem.loaded_specs.key?(gem.to_s)
          # providers << AI::Providers::InstanceFactory.create(config)
          providers << AI::Provider.new(name: config.fetch(:name), config: config)
        end
      end
      providers
    end
  end
end
