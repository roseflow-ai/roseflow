# frozen_string_literal: true

require "spec_helper"
require "roseflow/text/word_splitter"

module Roseflow
  module Text
    RSpec.describe WordSplitter do
      context "a successful split" do
        let(:text) { "This is a piece of text that will be divided into chunks." }
        let(:splitter) { described_class.new(chunk_size: 20, chunk_overlap: 1) }

        it "splits the text" do
          result = splitter.split(text)

          expect(result).to be_a Array
          expect(result).to eq ["This is a piece of", "of text that will", "will be divided into", "into chunks."]
          result.each do |r|
            expect(r.size).to be <= 20
          end
        end
      end

      context "a long text" do
        let(:text) { File.read("spec/fixtures/text/fragment.txt") }
        let(:splitter) { described_class.new(chunk_size: 1000, chunk_overlap: 5) }

        it "splits the text" do
          result = splitter.split(text)

          expect(result).to be_a Array
          result.each do |r|
            expect(r.size).to be <= 1000
          end
        end
      end
    end
  end
end
