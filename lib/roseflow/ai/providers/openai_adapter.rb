# frozen_string_literal: true

require "roseflow/ai/providers/base_adapter"

module Roseflow
  module AI
    module Providers
      class OpenAIAdapter < BaseAdapter
        def models
          @provider.models
        end
      end
    end
  end
end
