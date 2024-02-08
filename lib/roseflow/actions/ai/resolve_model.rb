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
          model = Registry.get(:models).find(context[:model])
          context.fail_and_return!("Model #{context[:model]} not found") unless model
          context[:llm] = model
        end
      end
    end
  end
end
