# frozen_string_literal: true

module Roseflow
  module Reasoning
    class SkeletonPoint < Dry::Struct
      transform_keys(&:to_sym)

      attribute :order, Types::Integer
      attribute :text, Types::String

      def to_s
        "#{order}. #{text}"
      end
    end
  end
end
