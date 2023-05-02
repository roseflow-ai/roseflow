# frozen_string_literal: true

RSpec.describe Interactions::GithubRepositoryChat do
  let(:prompt) { GithubChatPrompt.new("Describe me how to use OpenAI models with Roseflow.") }
  let(:ctx) do
    Roseflow::InteractionContext.make(
      provider: :openai,
      model: "gpt-3.5-turbo",
      repository_url: "https://github.com/roseflow-ai/roseflow-openai",
      prompt: prompt
    )
  end

  describe "" do
    
  end
end