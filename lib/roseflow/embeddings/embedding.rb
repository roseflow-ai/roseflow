# frozen_string_literal: true

require "roseflow/primitives/vector"

module Roseflow
  module Embeddings
    EmbeddingModelNotSpecifiedError = Class.new(StandardError)

    class Embedding
      attr_reader :vector
      attr_writer :input

      def initialize(**kwargs)
        @input = kwargs.fetch(:input, nil)
        @model = kwargs.fetch(:model, nil)
        @vector = kwargs.fetch(:vector, nil)
      end

      def call
        raise ArgumentError, "An input must be provided" unless @input
        raise EmbeddingModelNotSpecifiedError, "An embedding model must be specified" unless @model
        # response = @model.call(:embedding, model: @model.name, input: @input)
        response = @model.embed(input: @input)
        embedding = response.embedding
        @vector = Primitives::Vector.new(values: embedding.vector, dimensions: embedding.length)
        self
      end
    end # Embedding
  end # Embeddings
end # Roseflow
