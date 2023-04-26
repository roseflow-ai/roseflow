# frozen_string_literal: true

module Roseflow
  module AI
    class Model
      attr_reader :name, :provider

      def initialize(name:, provider:)
        @name = name
        @provider = provider
        @model_ = provider.models.find(name)
      end

      def call(operation, input)
        @model_.call(operation, input)
      end
    end # Model
  end # AI
end # Roseflow
