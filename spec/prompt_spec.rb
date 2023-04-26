# frozen_string_literal: true

require "spec_helper"

module Roseflow
  RSpec.describe Prompt do
    it "renders a simple prompt" do
      prompt = SimplePrompt.new
      expect(prompt.call).to eq "Hello, AI!"
    end

    it "renders a prompt with a variable" do
      prompt = VariablePrompt.new(name: "AI")
      expect(prompt.call).to eq "Hello, AI!"
    end

    it "renders a prompt with a nested prompt" do
      prompt = PromptWithNestedPrompt.new(name: "AI")
      expect(prompt.call).to eq "Instructions: Respond to my commands. Hello, AI!"
    end

    it "renders a prompt with a nested prompt and a variable" do
      prompt = PromptWithNestedPromptWithVariables.new(name: "AI", persona: "helpful bot")
      expect(prompt.call).to eq "Instructions: Respond to my commands as helpful bot. Hello, AI!"
    end
  end
end