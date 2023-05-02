# frozen_string_literal: true

require "roseflow/text/recursive_character_splitter"

module Roseflow
  module Text
    class WordSplitter < RecursiveCharacterSplitter
      def initialize(separators = [" "], **kwargs)
        super(**kwargs)
        @separators = separators
      end
    end # WordSplitter
  end # Text
end # Roseflow