# frozen_string_literal: true

require "roseflow/interaction"

require_relative "./ask_llm"
require_relative "./load_repository"
require_relative "./prepare_vector_store"

class Interactions::GithubRepositoryChat
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(self.actions)
  end

  def self.actions
    [
      LoadRepository,
      PrepareVectorStore,
      AskLLM
    ]
  end
end