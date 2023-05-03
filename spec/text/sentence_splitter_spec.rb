# frozen_string_literal: true

require "spec_helper"
require "roseflow/text/sentence_splitter"

module Roseflow
  module Text
    RSpec.describe SentenceSplitter do
      let(:text) { File.read("spec/fixtures/text/markdown.md") }

      context "chunk overlap is 1" do
        let(:splitter) { SentenceSplitter.new(chunk_size: 1000, chunk_overlap: 1) }

        it "splits text into chunks by sentences" do
          result = splitter.split(text)
          expect(result).to be_a(Array)

          result.each do |r|
            expect(r).to be_a(String)
            expect(r.length).to be <= 1000
          end
        end
      end

      context "chunk overlap is more than 1" do
        let(:splitter) { SentenceSplitter.new(chunk_size: 1000, chunk_overlap: 2) }

        it "splits text into chunks by sentences" do
          result = splitter.split(text)
          expect(result).to be_a(Array)

          result.each do |r|
            expect(r).to be_a(String)
            expect(r.length).to be <= 1000
          end
        end
      end
    end
  end
end
