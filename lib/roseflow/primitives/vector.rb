# frozen_string_literal: true

require "roseflow/types"

module Roseflow
  module Primitives
    class Vector < Dry::Struct
      transform_keys(&:to_sym)

      attribute :values, Types::Array.of(Types::Number)
      attribute :dimensions, Types::Integer
    end # Vector
  end # Primitives
end # Roseflow
