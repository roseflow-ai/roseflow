# frozen_string_literal: true

require "roseflow/interaction"

require_relative "../actions/initialize_vector_store"
require_relative "../actions/embed_repository"

class Interactions::PrepareVectorStore
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(self.actions)
  end

  def self.actions
    [
      InitializeVectorStore,
      new_vector_store?(ctx)
    ].compact
  end

  def new_vector_store?(ctx)
    ctx.has_embeddings? ? nil : EmbedRepository
  end
end