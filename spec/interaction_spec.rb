# frozen_string_literal: true

require "spec_helper"

module Roseflow
  RSpec.describe Interaction do
    describe "Module setup" do
      it "is extended properly" do
        expect(Roseflow::Interaction).to respond_to(:with)
      end
    end
    
    let(:ctx) { InteractionContext.make(model: "gpt-3.5-turbo") }

    context "when #with is called with a hash" do
      before do
        expect(TestDoubles::DataLoadingAction).to receive(:execute)
          .with(ctx)
          .and_return(ctx)
        expect(TestDoubles::AnInferenceAction).to receive(:execute)
          .with(ctx)
          .and_return(ctx)
      end

      it "implicitly creates a Context and passes it to the actions" do
        result = TestDoubles::SimpleInteraction.call(model: "gpt-3.5-turbo")
        expect(result).to eq ctx
      end
    end

    context "when #with is called with a Context" do
      before do
        expect(TestDoubles::DataLoadingAction).to receive(:execute)
          .with(ctx)
          .and_return(ctx)
        expect(TestDoubles::AnInferenceAction).to receive(:execute)
          .with(ctx)
          .and_return(ctx)
      end

      it "uses the passed Context without recreating it" do
        result = TestDoubles::SimpleInteraction.call(ctx)
        expect(result).to eq ctx
      end
    end

    context "when no Actions are specified" do
      it "throws a RuntimeError" do
        expect { TestDoubles::SimpleInteraction.perform_without_actions(ctx) }.to raise_error(RuntimeError, "No action(s) were provided")
      end
    end

    context "when Interaction is nested and reduced within another" do
      let(:reduced) { TestDoubles::NestingInteraction.call(ctx) }
      let(:interaction) { TestDoubles::NotExplicitlyReturningContextInteraction.call(ctx) }

      it "reduces an interaction which returns something" do
        expect(interaction).to eq [1,2,3]
      end

      it "adds :foo and :bar to the context" do
        reduced
        expect(ctx.foo).to eq [1,2,3]
        expect(ctx.bar).to eq ctx.foo
      end

      it "returns the context" do
        expect(reduced).to eq ctx
      end
    end

    context "can add items to context" do
      specify "with #add_to_context" do
        result = TestDoubles::AnInteractionThatAddsToContext.call
        expect(result.strongest_avenger).to eq "Thor"
        expect(result.last_jedi).to eq "Rey"
      end
    end

    context "can assign key aliases" do
      specify "with #add_aliases" do
        result = TestDoubles::AnInteractionThatAddsAliases.call
        expect(result[:foo]).to eq :bar
        expect(result[:baz]).to eq :bar
      end
    end
  end
end