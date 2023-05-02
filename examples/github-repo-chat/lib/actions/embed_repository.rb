# frozen_string_literal: true

require "roseflow/action"
require "roseflow/vector_stores/base"
require_relative "../repository_file"

class Actions::EmbedRepository
  extend Roseflow::Action

  expects :repository
  expects :vector_store

  executed do |ctx|
    # Check if the vector store already has embeddings for given repository
    # If so, we can skip this action
    next if ctx.vector_store.has_embeddings?(ctx.repository)

    # Otherwise, we need to embed the repository
    embed_repository(ctx.repository, ctx.vector_store)
  end

  def self.embed_repository(repository, vector_store)
    repository.files.each do |file_path, content|
      unless file_is_embedded?(vector_store, file_path, repository.name)
        embedding = RepositoryFile.new(file_path, content)
        vector = vector_store.build_vector(file_path.to_s, embedding.embedding.vector)
        vector_store.create_vector("github", vector, namespace: repository.name)
      end
    end
  end

  def self.file_is_embedded?(vector_store, file_path, repository_name)
    vector_store.find("github", file_path.to_s, namespace: repository_name)
  end
end