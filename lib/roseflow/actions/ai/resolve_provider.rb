# frozen_string_literal: true

require "roseflow/action"
require "roseflow/ai/provider"
require "roseflow/openai/config"

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

        private

        def self.resolve_provider(provider)
          case provider
          when :openai
            Roseflow::AI::Provider.new(name: :openai, credentials: Roseflow::OpenAI::Config.new)
          end
        end
      end
    end
  end
end
