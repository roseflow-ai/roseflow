# frozen_string_literal: true

require "roseflow/action"
require "roseflow/ai/model"

module Roseflow
  module Actions
    module AI
      class ResolveModel
        extend Roseflow::Action

        expects :model
        promises :llm

        executed do |context|
          model = context.provider.models.find(context[:model])

          unless model
            context.fail_and_return!("Model #{context[:model]} not found")
          end

          context[:llm] = Roseflow::AI::Model.new(name: model.name, provider: context.provider)
        end
      end
    end
  end
end
