# frozen_string_literal: true

require "spec_helper"
require "roseflow/text/splitter"

module Roseflow
  module Text
    RSpec.describe Splitter do
      describe "Initialization" do
        it "should raise error if chunk overlap is greater than chunk size" do
          expect { described_class.new(chunk_size: 10, chunk_overlap: 11) }.to raise_error(ArgumentError)
        end
      end

      describe "Splitting" do
        let(:splitter) { described_class.new(chunk_size: 10, chunk_overlap: 5) }

        it "should raise NotImplementedError" do
          expect { splitter.split("some text") }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
