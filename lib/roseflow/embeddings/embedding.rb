# frozen_string_literal: true

module Roseflow
  module Embeddings
    EmbeddingModelNotSpecifiedError = Class.new(StandardError)
    
    class Embedding
      attr_reader :length, :vector
      attr_writer :input

      def initialize(**kwargs)
        @length = kwargs.fetch(:length, 1024)
        @input = kwargs.fetch(:input, nil)
        @model = kwargs.fetch(:model, nil)
        @vector = kwargs.fetch(:vector, nil)
      end

      def call
        raise ArgumentError, "An input must be provided" unless @input
        raise EmbeddingModelNotSpecifiedError, "An embedding model must be specified" unless @model
        response = @model.provider.create_embedding(model: @model, input: @input)
        response.embedding
      end
    end # Embedding
  end # Embeddings
end # Roseflow
