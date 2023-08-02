# frozen_string_literal: true

require "spec_helper"
require "roseflow/reasoning/skeleton_of_thought"

module Roseflow
  module Reasoning
    RSpec.describe SkeletonOfThought, skip: true do
      let(:model) { Registry.get(:models).find("gpt-3.5-turbo") }
      let(:prompt) { "What is the meaning of life?" }
      let(:ctx) { Roseflow::InteractionContext.make(model: model, prompt: prompt) }
      let(:thought) { described_class.call(ctx) }

      describe "#call" do
        it "returns a result" do
          VCR.use_cassette("reasoning/skeleton_of_thought") do
            expect(thought).to be_success
            expect(thought[:answer]).to be_a Roseflow::OpenAI::Choice
            puts thought[:answer].to_s
          end
        end
      end
    end
  end
end
