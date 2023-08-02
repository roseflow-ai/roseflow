# frozen_string_literal: true

require "async"

module Roseflow
  module Reasoning
    class ThoughtGenerator
      def initialize(model)
        @model = model
      end

      def max_tokens
        2048
      end

      def temperature
        1.0
      end

      def think(prompt, k)
        Sync do |parent|
          Array.new(k) do
            parent.async do
              model.chat(messages: [prompt], max_tokens: max_tokens, temperature: temperature).response
            end
          end.map(&:wait)
        end
      end

      private

      attr_reader :model
    end
  end
end
