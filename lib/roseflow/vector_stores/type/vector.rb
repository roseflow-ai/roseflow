# frozen_string_literal: true

require "active_model/type"

module Roseflow
  module VectorStores
    module Type
      class Vector < ActiveModel::Type::Value
        def initialize(dimensions:, model:, attribute_name:)
          super()
          @dimensions = dimensions
          @model = model
          @attribute_name = attribute_name
        end

        def self.cast(value, dimensions:)
          value = value.to_a.map(&:to_f)

          raise Error, "Values must be finite" unless value.all?(&:finite?)

          value
        end

        def cast(value)
          self.class.cast(value, dimensions: @dimensions) unless value.nil?
        end

        def serialize(value)
          raise NotImplementedError
        end

        def deserialize(value)
          raise NotImplementedError
        end
      end
    end
  end
end
