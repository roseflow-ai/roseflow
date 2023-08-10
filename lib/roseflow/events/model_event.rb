# frozen_string_literal: true

require "omnes"

module Roseflow
  module Events
    class ModelEvent
      include Omnes::Event

      def initialize(model:, provider:, data:)
        @model = model.name
        @provider = provider.name
        @data = data
      end
    end
  end
end