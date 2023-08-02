# frozen_string_literal: true

require "spec_helper"
require "roseflow/ai/model"

module Roseflow
  module AI
    RSpec.describe Model do
      describe "#initialize" do
        let(:model) { described_class.new(name: "gpt-3.5-turbo") }

        it "creates a new instance of Model" do
          VCR.use_cassette("ai/model/initialize") do
            expect(model).to be_a(Model)
            expect(model.name).to eq "gpt-3.5-turbo"
            expect(model.provider).to eq :openai
          end
        end

        it "raises an error if the model does not exist" do
          expect { described_class.new(name: "foobar-turbo") }.to raise_error(ModelRepository::ModelNotFoundError)
        end

        it "raises an error if the model name is not provided" do
          expect { described_class.new }.to raise_error(ArgumentError).with_message("Name must be provided")
        end
      end

      describe "#operations" do
        it "returns a list of operations" do
          VCR.use_cassette("ai/model/operations") do
            model = described_class.new(name: "gpt-3.5-turbo")
            expect(model).to be_a(Model)
            expect(model).to respond_to(:operations)
            expect(model.operations).to be_a(Array)
          end
        end
      end
    end
  end # AI
end # Roseflow
