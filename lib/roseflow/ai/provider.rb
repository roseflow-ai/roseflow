# frozen_string_literal: true

require "roseflow/provider_repository"
require "roseflow/ai/providers/instance_factory"

module Roseflow
  module AI
    class Provider
      attr_reader :name

      def initialize(name:, config:)
        instance = create_adapted_instance(config)
        @name = name
        @instance = instance
      end

      def models
        @models ||= instance.models
      end

      def get_file_content(file_id)
        @instance.get_file_content(file_id)
      end

      private

      attr_reader :instance

      def create_adapted_instance(config)
        Providers::InstanceFactory.create(config)
      end
    end # Provider

    ProviderNotFoundError = ProviderRepository::ProviderNotFoundError
  end # AI
end # Roseflow
