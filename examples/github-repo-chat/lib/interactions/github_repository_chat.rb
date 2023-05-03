# frozen_string_literal: true

# This class represents an interaction that allows users to chat about
# a Github repository. It orchestrates the required actions to load
# the repository, prepare the vector store, and ask the LLM about the repository.
#
# Example usage:
#   question = "What is the repository about?"
#   response = Interactions::GithubRepositoryChat.call(
#     question: question,
#     repository_url: "https://github.com/ljuti/roseflow"
#   )

require "roseflow/interaction"

require_relative "./ask_llm"
require_relative "./load_repository"
require_relative "./prepare_vector_store"

class Interactions::GithubRepositoryChat
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(actions)
  end

  # Define the sequence of actions (or interactions) to be performed
  # by the interaction.
  def self.actions
    [
      LoadRepository, # Load repository from Github and prepare it
      PrepareVectorStore, # Prepare vector store for querying
      AskLLM # Ask the LLM about the repository
    ]
  end
end
