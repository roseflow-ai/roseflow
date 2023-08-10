# frozen_string_literal: true

module Roseflow
  module AI
    module Models
      class Configuration < Anyway::Config
        config_name :ai_model

        attr_config :name
        attr_config instrumentation: false
        attr_config temperature: 1.0
        attr_config top_p: 1.0
        attr_config n: 1
        attr_config stream: false
        attr_config stream_events: false
        attr_config stop: nil
        attr_config max_tokens: 2048
        attr_config presence_penalty: 0.0
        attr_config frequency_penalty: 0.0
        attr_config user: nil
      end
    end
  end
end