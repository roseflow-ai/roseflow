# frozen_string_literal: true

require "roseflow/action"
require "sequel"

class Actions::LoadFilesToDocumentDatabase
  extend Roseflow::Action

  expects :repository
  promises :database

  executed do |ctx|
    ctx[:database] = load_files_to_database(ctx.repository)
  end
end