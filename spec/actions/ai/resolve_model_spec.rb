# frozen_string_literal: true

require "spec_helper"
require "roseflow/actions/ai/resolve_model"

module Roseflow
  module Actions
    module AI
      RSpec.describe ResolveModel do
        let(:action) { described_class }
        let(:model) { "gpt-3.5-turbo" }

        describe "#call" do
          context "can be called" do
            let(:provider) { Registry.get(:providers).find(:openai) }
            let(:ctx) { Roseflow::InteractionContext.make(provider: provider, model: model) }

            it "calls the action" do
              VCR.use_cassette("ai/resolve_model") do
                expect(action).to receive(:execute)
                action.execute(ctx)
              end
            end
          end

          context "when the model is found" do
            let(:provider) { Registry.get(:providers).find(:openai) }
            let(:ctx) { Roseflow::InteractionContext.make(provider: provider, model: model) }

            before(:each) do
              models = [double(name: model)]
              allow(provider).to receive(:models).and_return(models)
              allow(models).to receive(:find).with(model).and_return(models.first)
            end

            it "returns a result" do
              VCR.use_cassette("ai/resolve_model") do
                result = described_class.execute(ctx)
                expect(result).to be_a Roseflow::InteractionContext
              end
            end

            it "adds a new LLM to the context" do
              VCR.use_cassette("ai/resolve_model") do
                result = action.execute(ctx)
                expect(result.llm).to be_a Roseflow::AI::Model
              end
            end
          end

          context "when the model is not found" do
            let(:provider) { Registry.get(:providers).find(:openai) }
            let(:ctx) { Roseflow::InteractionContext.make(provider: provider, model: "gpt-10") }

            it "the context fails" do
              VCR.use_cassette("ai/resolve_model") do
                expect { action.execute(ctx) }.to raise_error Roseflow::ModelRepository::ModelNotFoundError
              end
            end
          end
        end
      end
    end
  end
end
