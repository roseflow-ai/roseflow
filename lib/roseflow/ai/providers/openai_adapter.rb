# frozen_string_literal: true

require "roseflow/ai/providers/base_adapter"

module Roseflow
  module AI
    module Providers
      class OpenAIAdapter < BaseAdapter
        def models
          @provider.models
        end

        def get_file_content(file_id)
          @provider.get_file_content(file_id)
        end
      end
    end
  end
end
