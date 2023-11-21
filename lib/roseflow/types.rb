# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry.Types()

  Number = Types::Float | Types::Integer
  StringOrNil = Types::String | Types::Nil

  module OpenAI
    FunctionCallObject = Types::Hash
    StringOrObject = Types::String | FunctionCallObject
    StringOrArray = Types::String | Types::Array

    VisionChatMessageContent = Types::Hash.schema(
      text: Types::String,
      type: Types::String.default("text"),
    )

    VisionImageMessageContent = Types::Hash.schema(
      image_url: Types::Hash.schema(url: Types::String, detail: Types::String.default("auto")),
      type: Types::String.default("image_url"),
    )
  end
end
