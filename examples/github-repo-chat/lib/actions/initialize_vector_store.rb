# frozen_string_literal: true

require "roseflow/action"

class Actions::InitializeVectorStore
  extend Roseflow::Action

  expects :provider
  promises :vector_store

  executed do |ctx|
    ctx[:vector_store] = initialize_vector_store(ctx.provider)
  end

  def self.initialize_vector_store(provider)
    case provider
    when :pinecone
      require "roseflow/pinecone/vector_store"
      Roseflow::Pinecone::VectorStore.new
    else
      raise ArgumentError, "Unknown provider: #{provider}"
    end
  end
end