# frozen_string_literal: true

require "spec_helper"
require "roseflow/actions/ai/resolve_provider"

module Roseflow
  module Actions
    module AI
      RSpec.describe ResolveProvider do
        let(:action) { described_class }
        let(:provider) { :openai }
        let(:ctx) { Roseflow::InteractionContext.make(provider: provider) }

        describe "#call" do
          it "calls the action" do
            expect(action).to receive(:execute)
            action.execute(ctx)
          end

          it "returns a result" do
            result = described_class.execute(ctx)
            expect(result).to be_a Roseflow::InteractionContext
          end

          it "adds a new provider to the context" do
            result = action.execute(ctx)
            expect(result.provider).to be_a Roseflow::AI::Provider
          end
        end
      end
    end
  end
end
