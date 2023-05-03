# frozen_string_literal: true

require "roseflow/interaction"

class Interactions::LoadFilesToDocumentDatabase
  extend Roseflow::Interaction

  def self.call(ctx)
    with(ctx).reduce(actions)
  end

  def self.actions
    [
      SplitFilesToDocuments,
      LoadDocumentsToDatabase
    ]
  end
end
