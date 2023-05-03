# frozen_string_literal: true

require_relative "../spec_helper"
require "roseflow/pinecone"
require "roseflow/pinecone/vector_store"

RSpec.describe Actions::EmbedRepository do
  let(:repository) { Repository.new("ulid-ruby", "https://github.com/abachman/ulid-ruby.git", {"ulid-ruby.gemspec": "This is a gemspec for the gem"}) }
  let(:ctx) do
    Roseflow::InteractionContext.make(
      repository: repository,
      vector_store: Roseflow::Pinecone::VectorStore.new
    )
  end

  describe "embedding a repository" do
    let(:action) { described_class.execute(ctx) }

    it "embeds the files of the repository to the vector store" do
      expect(action).to be_a_success
      expect(action.vector_store).to be_a(Roseflow::VectorStores::Base)
    end
  end
end
