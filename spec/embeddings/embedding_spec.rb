# frozen_string_literal: true

require "spec_helper"
require "roseflow/embeddings/embedding"

module Roseflow
  module Embeddings
    RSpec.describe Embedding do
      subject { described_class.new }

      describe "Initialization and defaults" do
        it "can be instantiated" do
          expect(subject).to be_instance_of(described_class)
        end
  
        it "responds to a set of methods" do
          expect(subject).to respond_to(:length)
          expect(subject).to respond_to(:vector)
          expect(subject).to respond_to(:input=)
          expect(subject).to respond_to(:call)        
        end
  
        it "has a default length of 1024" do
          expect(subject.length).to eq(1024)
        end
      end

      describe "#call", skip: "an AI model object must be passed to the class and it's not implemented yet" do
        subject(:no_input) { described_class.new }
        subject(:no_model) { described_class.new(input: "test") }
        subject { described_class.new(input: "test", model: "text-embedding-ada-002") }

        it "fails if no input has been provided" do
          expect{ no_input.call }.to raise_error ArgumentError
        end

        it "must know which embedding model to use" do
          expect{ no_model.call }.to raise_error EmbeddingModelNotSpecifiedError
        end

        it "returns a vector" do
          VCR.use_cassette("openai/embedding", record: :new_episodes) do
            expect(subject.call).to be_instance_of described_class
            embedding = subject.call

            expect(embedding.vector).to be_instance_of Array
            expect(embedding.length).to eq(1536)
          end
        end
      end
    end
  end
end
