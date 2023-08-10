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
          expect(subject).to respond_to(:vector)
          expect(subject).to respond_to(:input=)
          expect(subject).to respond_to(:call)
        end

        it "has no vector by default" do
          expect(subject.vector).to be_nil
        end
      end

      describe "#call" do
        subject(:no_input) { described_class.new }
        subject(:no_model) { described_class.new(input: "test") }

        let(:model) { Registry.get(:models).find("text-embedding-ada-002") }

        subject { described_class.new(input: "test", model: model) }

        it "fails if no input has been provided" do
          expect { no_input.call }.to raise_error ArgumentError
        end

        it "must know which embedding model to use" do
          expect { no_model.call }.to raise_error EmbeddingModelNotSpecifiedError
        end

        it "returns itself with a vector" do
          VCR.use_cassette("openai/embedding", record: :new_episodes) do
            expect(subject.call).to be_instance_of described_class
            embedding = subject.call

            expect(embedding.vector).to be_instance_of Primitives::Vector
            expect(embedding.vector.dimensions).to eq(1536)
          end
        end
      end
    end
  end
end
