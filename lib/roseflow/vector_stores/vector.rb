# frozen_string_literal: true

require "dry-types"

module Types
  include Dry.Types()
  Number = Types::Float | Types::Integer
end

module Roseflow
  module VectorStores
    class Vector < Dry::Struct
      transform_keys(&:to_sym)

      attribute :values, Types::Array.of(Types::Number)
      attribute :dimensions, Types::Integer
    end # Vector
  end # VectorStores
end # Roseflow
