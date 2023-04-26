# frozen_string_literal: true

require "dry-struct"

module Roseflow
  module Text
    class TokenizedText < Dry::Struct
      attribute :text, Types::String
      attribute :tokens, Types::Array.of(Types::Integer)

      def token_count
        tokens.count
      end

      def to_s
        text
      end
    end
  end
end
