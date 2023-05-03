# frozen_string_literal: true

require "roseflow/interaction"

require_relative "../actions/initialize_vector_store"
require_relative "../actions/embed_repository"

class Interactions::PrepareVectorStore
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(actions)
  end

  def self.actions
    [
      InitializeVectorStore,
      reduce_if(->(ctx) { ctx.vector_store.has_embeddings? }, EmbedRepository)
    ]
  end
end
