# frozen_string_literal: true

require "roseflow/event_bus"
require "roseflow/model_repository"
require "roseflow/provider_repository"

module Roseflow
  class UnknownRegistryKeyError < StandardError; end

  class Registry
    include Singleton

    def initialize
      @store = {}
    end

    def keys
      @store.keys
    end

    def register(key, value)
      @store.store(key, value)
    end

    def get(key)
      @store.fetch(key) { initialize_instance(key) || raise(UnknownRegistryKeyError, "Unknown registry key #{key}") }
    end

    def self.get(key)
      instance.get(key)
    end

    def self.register(name, value)
      instance.register(name, value)
    end

    private

    def initialize_instance(key)
      case key
      when :providers
        register(:providers, ProviderRepository.new)
      when :models
        register(:models, ModelRepository.new)
      when :events
        register(:events, EventBus.new)
      when :default_model
        register(:default_model, AI::Model.load("gpt-3.5-turbo"))
      end
    end
  end
end
