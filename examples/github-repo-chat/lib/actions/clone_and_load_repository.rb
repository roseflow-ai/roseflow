# frozen_string_literal: true

require "roseflow/action"
require "rugged"
require "tmpdir"

require_relative "../repository"

class Actions::CloneAndLoadRepository
  extend Roseflow::Action

  expects :repository_url
  promises :repository

  executed do |ctx|
    ctx[:repository] = clone_repository(ctx.repository_url)
  end

  def self.clone_repository(repository_url)
    files = {}
    Dir.mktmpdir do |dir|
      repository = Rugged::Repository.clone_at(repository_url, dir)
      head_commit = repository.head.target
      tree = repository.lookup(head_commit.tree.oid)

      tree.walk_blobs(:preorder) do |root, entry|
        file_path = "#{root}#{entry[:name]}"
        files[file_path] = repository.lookup(entry[:oid]).content
      end

      name = repository_url.split("/").last.gsub(".git", "")

      return Repository.new(name, repository_url, files)
    end
  end
end