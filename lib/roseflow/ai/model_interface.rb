# frozen_string_literal: true

module Roseflow
  module AI
    module ModelInterface
      def call(**options)
        raise NotImplementedError, "Model must implement #call"
      end

      def chat(**options)
        raise NotImplementedError, "Model must implement #chat"
      end

      def completion(**options)
        raise NotImplementedError, "Model must implement #completion"
      end

      def operations
        raise NotImplementedError, "Model must implement #operations"
      end
    end
  end
end
