# frozen_string_literal: true

require "roseflow/interaction"
require "roseflow/actions/ai/resolve_model"
require "roseflow/actions/ai/resolve_provider"

module Roseflow
  module Interactions
    module AI
      class InitializeLlm
        extend Roseflow::Interaction

        def self.call(context)
          with(context).reduce(actions)
        end

        def self.actions
          [
            Actions::AI::ResolveProvider,
            Actions::AI::ResolveModel
          ]
        end
      end
    end
  end
end