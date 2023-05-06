# frozen_string_literal: true

module Roseflow
  module Chat
    class Personality < Dry::Struct
      attribute :name, Types::Strict::String
      attribute :description, Types::Strict::String
    end
  end
end
