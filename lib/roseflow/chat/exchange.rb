# frozen_string_literal: true

require "roseflow/chat/message"

module Roseflow
  module Chat
    class Exchange < Dry::Struct
      attribute :prompt, UserMessage
      attribute :response, ModelMessage
    end
  end
end
