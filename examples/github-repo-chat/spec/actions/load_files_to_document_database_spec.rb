# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Actions::LoadFilesToDocumentDatabase do
  let(:repository_url) { "https://github.com/abachman/ulid-ruby.git" }
  let(:ctx) do
    Roseflow::InteractionContext.make(
      repository_url: repository_url
    )
  end

  before do
    @context = Actions::CloneAndLoadRepository.execute(ctx)
  end

  describe "loading files to document database" do
    it "loads the files" do
      expect(action).to be_a_success
      expect(action.database.files.count).to be > 5
    end
  end
end