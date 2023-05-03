# frozen_string_literal: true

# This class represents an action that clones and loads a repository from a
# given URL. The action expects a repository URL as input and returns a
# Repository object containing the repository's data.
#
# Example usage:
#   repository = Actions::CloneAndLoadRepository.call(
#     repository_url: "https://github.com/ljuti/roseflow.git"
#   )

require "roseflow/action"
require "rugged"
require "tmpdir"

require_relative "../repository"

class Actions::CloneAndLoadRepository
  extend Roseflow::Action

  # Define the inputs and outputs of the action
  expects :repository_url # Input: The URL of the repository to clone
  promises :repository # Output: a Repository object

  executed do |ctx|
    ctx[:repository] = clone_repository(ctx.repository_url)
  end

  # Clone a repository from a given URL, load its data, and create a Repository object.
  #
  # @param repository_url [String] The URL of the repository to clone
  # @return [Repository] A Repository object containing the repository's data
  def self.clone_repository(repository_url)
    files = {}
    Dir.mktmpdir do |dir|
      # Clone the repository into a temporary directory
      repository = Rugged::Repository.clone_at(repository_url, dir)
      head_commit = repository.head.target
      tree = repository.lookup(head_commit.tree.oid)

      # Collect the content of each file in the repository
      tree.walk_blobs(:preorder) do |root, entry|
        file_path = "#{root}#{entry[:name]}"
        files[file_path] = repository.lookup(entry[:oid]).content
      end

      # Extract the repository's name from the URL and create a Repository object
      name = repository_url.split("/").last.gsub(".git", "")
      return Repository.new(name, repository_url, files)
    end
  end
end
