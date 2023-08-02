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
  end
end
