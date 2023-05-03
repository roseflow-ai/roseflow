# frozen_string_literal: true

module Roseflow
  module Text
    class Splitter
      def initialize(chunk_size:, chunk_overlap:)
        raise ArgumentError, "chunk overlap cannot exceed chunk size" if chunk_overlap > chunk_size

        @chunk_size = chunk_size
        @chunk_overlap = chunk_overlap
      end

      def split(text)
        raise NotImplementedError, "this class must be extended and the #split method implemented"
      end
    end
  end
end
