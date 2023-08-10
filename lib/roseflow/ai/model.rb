# frozen_string_literal: true

require "roseflow/model_repository"
require "roseflow/provider_repository"
require "roseflow/ai/models/configuration"
require "roseflow/ai/models/instance_factory"
require "roseflow/ai/models/openai_adapter"
require "roseflow/ai/models/openrouter_adapter"

module Roseflow
  module AI
    class ModelInstanceNotFoundError < StandardError; end

    class Model
      attr_reader :name, :config

      delegate :chat, :embed, :config, to: :instance

      def initialize(name: nil, provider: nil)
        raise ArgumentError, "Name must be provided" if name.nil?
        provider = resolve_provider(name, provider)
        instance = create_adapted_instance(name, provider)
        @name = name
        @instance = instance
        @_provider = provider
        # @config = instance.configuration
      end

      def config=(config)
        @instance.configuration = config if config.is_a?(Models::Configuration)
      end

      def provider
        _provider.name
      end

      def call(operation, options, &block)
        instance.call(operation, options, &block)
      end

      def operations
        instance.operations
      end

      def self.load(name)
        Registry.get(:models).find(name)
      end

      private

      attr_reader :instance, :_provider

      def resolve_provider(name, provider)
        if provider.nil?
          provider_name = Registry.get(:models).find(name).provider
          Registry.get(:providers).find(provider_name)
        else
          return provider if provider.instance_of?(Provider)
          Registry.get(:providers).find(provider)
        end
      end

      def create_adapted_instance(name, provider)
        Models::InstanceFactory.create(name, provider)
      end
    end # Model
  end # AI
end # Roseflow
