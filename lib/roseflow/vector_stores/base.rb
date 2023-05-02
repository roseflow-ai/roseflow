# frozen_string_literal: true

module Roseflow
  module VectorStores
    class Base
      def has_embeddings?(klass)
        false
      end

      def list_vectors(namespace = nil)
        raise NotImplementedError, "You must implement the #list_vectors method in your vector store"
      end

      def build_vector(id, attrs)
        raise NotImplementedError, "You must implement the #build_vector method in your vector store"
      end

      def create_vector(vector)
        raise NotImplementedError, "You must implement the #create_vector method in your vector store"
      end

      def delete_vector(name)
        raise NotImplementedError, "You must implement the #delete_vector method in your vector store"
      end

      def update_vector(vector)
        raise NotImplementedError, "You must implement the #update_vector method in your vector store"
      end

      def query(query)
        raise NotImplementedError, "You must implement the #query method in your vector store"
      end

      def find(query)
        raise NotImplementedError, "You must implement the #find method in your vector store"
      end
    end
  end
end