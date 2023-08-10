# frozen_string_literal: true

require "omnes"

module Roseflow
  module Events
    module Model
      class StreamingEvent
        include Omnes::Event

        attr_reader :body, :stream_id

        def initialize(body:, stream_id:)
          @body = body
          @stream_id = stream_id
        end

        def omnes_event_name
          :model_streaming_event
        end
      end
    end
  end
end