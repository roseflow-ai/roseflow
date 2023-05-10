# frozen_string_literal: true

module Roseflow
  module Text
    class Completion
      def initialize(input)
        @input = input
      end

      # Creates a new completion for the given input.
      def call(model:, prompt:, **options)
        provider.completions(model: model, prompt: @input, **options).choices
      end
    end
  end
end
