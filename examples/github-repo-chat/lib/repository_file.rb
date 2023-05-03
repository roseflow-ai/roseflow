# frozen_string_literal: true

require "ulid"

class RepositoryFile < Roseflow::Embeddings::Base
  def initialize(name:, content:, **kwargs)
    @name = name
    @content = content
    @id = ULID.generate
    @token_count = kwargs[:token_count]
    @tokens = kwargs[:tokens]
  end

  def embedding
    @embedding ||= create_embedding
  end

  private

  def create_embedding
    provider.embedding(model: embedding_model, input: @content)
  end

  def provider
    @provider ||= Roseflow::OpenAI::Provider.new
  end

  def embedding_model
    provider.models.embeddable.find { |model| model.name == "text-embedding-ada-002" } || openai.models.embeddable.first
  end
end
