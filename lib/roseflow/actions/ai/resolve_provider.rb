# frozen_string_literal: true

require "roseflow/action"
require "roseflow/ai/provider"

module Roseflow
  module Actions
    module AI
      class ResolveProvider
        extend Roseflow::Action

        expects :provider
        promises :provider

        executed do |context|
          context[:provider] = resolve_provider(context[:provider])
        end

        def self.resolve_provider(provider)
          Registry.get(:providers).find(provider)
        end
      end
    end
  end
end
