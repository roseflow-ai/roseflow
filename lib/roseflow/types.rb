# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry.Types()

  Number = Types::Float | Types::Integer
end
