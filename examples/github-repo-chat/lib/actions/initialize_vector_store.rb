# frozen_string_literal: true

# This class represents an action that initializes a vector store based on a
# given provider. The action expects a provider as input and returns a
# VectorStore object.
#
# Example usage:
#   vector_store = Actions::InitializeVectorStore.execute(provider: :pinecone)

require "roseflow/action"

class Actions::InitializeVectorStore
  # Make it a Roseflow action
  extend Roseflow::Action

  # Define the inputs and outputs of the action
  expects :provider # Input: The vector store provider to use
  promises :vector_store # Output: a VectorStore object

  executed do |ctx|
    ctx[:vector_store] = initialize_vector_store(ctx.provider)
  end

  # Initialize a vector store based on the given provider.
  #
  # @param provider [Symbol] The symbol representing the vector store provider
  # @return [Object] A VectorStore object corresponding to the given provider
  # @raise [ArgumentError] If the provider is unknown
  def self.initialize_vector_store(provider)
    case provider
    when :pinecone
      # Initialize a Pinecone vector store
      require "roseflow/pinecone/vector_store"
      Roseflow::Pinecone::VectorStore.new
    else
      # Raise an error if the provider is unknown
      raise ArgumentError, "Unknown provider: #{provider}"
    end
  end
end
