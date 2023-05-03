# frozen_string_literal: true

require "roseflow/interaction"

require_relative "../actions/clone_and_load_repository"

class Interactions::LoadRepository
  extend Roseflow::Interaction

  def self.call(context = {})
    with(context).reduce(actions)
  end

  def self.actions
    [
      CloneAndLoadRepository,
      LoadFilesToDocumentDatabase
    ]
  end
end
