# frozen_string_literal: true

require "roseflow/text/splitter"

module Roseflow
  module Text
    class WordSplitter < Splitter
      def initialize(language: "en", **kwargs)
        super(**kwargs)
        @language = language
      end

      attr_reader :chunk_size, :chunk_overlap

      def split(text)
        segments = text.split(" ")
        current_size = 0
        results = [[]]
      
        segments.each do |segment|
          if current_size + segment.size > chunk_size
            overlap = [results.last.last(chunk_overlap), segment].flatten
            current_size = overlap.sum(&:size) + chunk_overlap
            results << overlap
          else
            current_size += segment.size + results.last.size
            results.last << segment
          end
        end
      
        results.map { |r| r.join(" ") }
      end
    end
  end
end