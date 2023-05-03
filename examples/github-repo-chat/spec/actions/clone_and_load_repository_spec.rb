# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Actions::CloneAndLoadRepository do
  let(:repository_url) { "https://github.com/abachman/ulid-ruby.git" }
  let(:ctx) do
    Roseflow::InteractionContext.make(
      repository_url: repository_url
    )
  end

  describe "cloning and loading the repository" do
    let(:action) { described_class.execute(ctx) }

    it "returns a repository" do
      expect(action).to be_a_success
      expect(action.repository).to be_a(Repository)
    end

    it "sets repository attributes correctly" do
      expect(action.repository).to be_a(Repository)
      expect(action.repository.name).to eq "ulid-ruby"
      expect(action.repository.url).to eq repository_url
      expect(action.repository.files).not_to be_empty
    end
  end
end
