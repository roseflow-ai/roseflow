# frozen_string_literal: true

require "ulid"

class RepositoryFile < Roseflow::Embeddings::Base
  def initialize(name, content, metadata = {})
    @name = name
    @content = content
    @id = ULID.generate
    @metadata = metadata
  end

  def embedding
    @embedding ||= create_embedding
  end

  private

  def create_embedding
    # response = openai_client.create_embedding(model: openai_client.provider.models.embeddable.first, input: @content)
    # puts response
    # response
    openai.embedding(model: openai.models.embeddable.first, input: @content)
  end

  def openai_client
    # @openai_client ||= Roseflow::OpenAI::Client.new
  end

  def openai
    @openai ||= Roseflow::OpenAI::Provider.new
  end
end