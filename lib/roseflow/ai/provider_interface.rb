# frozen_string_literal: true

module Roseflow
  module AI
    module ProviderInterface
      def call
        raise NotImplementedError, "Provider must implement #call"
      end

      def chat
        raise NotImplementedError, "Provider must implement #chat"
      end

      def completion
        raise NotImplementedError, "Provider must implement #completion"
      end

      def models
        raise NotImplementedError, "Provider must implement #models"
      end
    end
  end
end
