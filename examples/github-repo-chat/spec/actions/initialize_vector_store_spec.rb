# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Actions::InitializeVectorStore do
  let(:ctx) do
    Roseflow::InteractionContext.make(
      provider: :pinecone
    )
  end

  describe "initializing the vector store" do
    let(:action) { described_class.execute(ctx) }

    it "returns a vector store" do
      expect(action).to be_a_success
      expect(action.vector_store).to be_a Roseflow::Pinecone::VectorStore
    end
  end
end