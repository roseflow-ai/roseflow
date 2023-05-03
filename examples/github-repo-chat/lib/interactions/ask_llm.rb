# frozen_string_literal: true

# This class represents an interaction that asks the LLM (Large Language Model)
# a question based on a given context. It orchestrates the required actions to
# initialize the LLM, create a prompt, and interact with the model.
#
# Example usage:
#   result = Interactions::AskLLM.call(context)

require "roseflow"
require "roseflow/interactions/ai/initialize_llm"

require_relative "../actions/create_prompt"

class Interactions::AskLLM
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(actions)
  end

  # Define the sequence of actions (or interactions) to be performed
  # by the interaction.
  def self.actions
    [
      Roseflow::Interactions::AI::InitializeLlm, # Initialize the LLM
      CreatePrompt, # Create a prompt for the LLM
      InteractWithModel # Interact with the LLM
    ]
  end
end
