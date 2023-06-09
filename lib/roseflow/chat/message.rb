# frozen_string_literal: true

require "dry-struct"
require "roseflow/types"

module Roseflow
  module Chat
    class Message < Dry::Struct
      attribute :role, Types::String
      attribute :content, Types::String
      attribute? :name, Types::String
      attribute? :token_count, Types::Integer

      def user?
        role == "user"
      end

      def system?
        role == "system"
      end

      def model?
        %w(system assistant).include?(role)
      end
    end

    class ModelMessage < Message
      attribute :role, Types::String.constrained(included_in: %w(system assistant))
    end

    class UserMessage < Message
      attribute :role, Types::String.constrained(included_in: %w(user))
    end

    class SystemMessage < Message
      attribute :role, Types::String.constrained(included_in: %w(system))
    end
  end
end
