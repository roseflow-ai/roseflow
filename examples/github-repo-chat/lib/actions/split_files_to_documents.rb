# frozen_string_literal: true

require "roseflow/action"
require "ulid"

class Actions::SplitFilesToDocuments
  extend Roseflow::Action

  expects :repository
  promises :documents

  executed do |ctx|
    splitter = initialize_splitter()
    tokenizer = initialize_tokenizer(ctx)
    ctx.repository.files.each do |file_path, content|
      chunks = splitter.split(content)
      tokenized = chunks.map { |chunk| tokenizer.encode(chunk) }
    end
  end

  def self.initialize_splitter
    Roseflow::Text::WordSplitter.new(chunk_size: 1000, chunk_overlap: 0)
  end

  def self.initialize_tokenizer(ctx)
    Roseflow::Tiktoken::Tokenizer.new(model: ctx.model.name)
  end
end