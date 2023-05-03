# frozen_string_literal: true

# This action splits the content of source code files into smaller chunks
# and tokenizing them into documents.
#
# It takes a repository as an input and returns an array of documents.

require "roseflow/action"
require "ulid"

class Actions::SplitFilesToDocuments
  extend Roseflow::Action

  # Define the inputs and outputs of the action
  expects :repository # Input: a repository object containing file data
  promises :documents # Output: Array of RepositoryFile objects representing documents

  executed do |ctx|
    # Initialize splitter and tokenizer instances
    splitter = initialize_splitter
    tokenizer = initialize_tokenizer(ctx)

    # Iterate over each file in the repository, split and tokenize its content
    ctx[:documents] = ctx.repository.files.each do |file_path, content|
      chunks = splitter.split(content) # Split the content into chunks
      tokenized = chunks.map { |chunk| tokenizer.encode(chunk) } # Tokenize each chunks

      # Create a RepositoryFile object for each chunk-token pair
      chunks.zip(tokenized).map do |chunk, tkn|
        RepositoryFile.new(
          name: file_path,
          content: chunk,
          tokens: tkn,
          token_count: tkn.length
        )
      end
    end
  end

  # Initialize a RecursiveCharacterSplitter instance with a chunk_size of 1000
  # and no overlap between chunks.
  #
  # @return [Roseflow::Text::RecursiveCharacterSplitter]
  def self.initialize_splitter
    Roseflow::Text::RecursiveCharacterSplitter.new(chunk_size: 1000, chunk_overlap: 0)
  end

  # Initialize a Tokenizer instance with the provided model from the context.
  #
  # @param ctx [Roseflow::Context] The context of the action execution
  # @return [Roseflow::Tiktoken::Tokenizer]
  def self.initialize_tokenizer(ctx)
    Roseflow::Tiktoken::Tokenizer.new(model: ctx.model.name)
  end
end
