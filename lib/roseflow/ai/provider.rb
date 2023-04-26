# frozen_string_literal: true

require "roseflow/openai/provider"

module Roseflow
  module AI
    class Provider
      def initialize(name:, credentials:)
        @name = name
        @credentials = credentials
        initialize_provider
      end

      def models
        @models ||= provider.models
      end

      private

      attr_reader :name, :credentials, :provider

      def initialize_provider
        case name
        when :openai
          @provider = Roseflow::OpenAI::Provider.new(credentials: credentials)
        end      
      end
    end # Provider
  end # AI
end # Roseflow
