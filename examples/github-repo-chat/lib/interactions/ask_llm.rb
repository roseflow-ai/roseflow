# frozen_string_literal: true

require "roseflow"
require "roseflow/interactions/ai/initialize_llm"

require_relative "../actions/create_prompt"

class Interactions::AskLLM
  extend Roseflow::Interaction

  # expects :model
  # expects :prompt
  # expects :provider

  # promises :response

  def self.call(context = {})
    with(context).reduce(self.actions)
  end

  def self.actions
    [
      Roseflow::Interactions::AI::InitializeLlm,
      CreatePrompt,
      InteractWithModel
    ]
  end
end