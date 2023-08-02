# frozen_string_literal: true

require "roseflow/ai/provider_interface"

module Roseflow
  module AI
    module Providers
      class BaseAdapter
        include ProviderInterface

        def initialize(provider)
          @provider = provider
        end
      end
    end
  end
end
