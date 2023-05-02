# frozen_string_literal: true

require "roseflow/action"

class Actions::InteractWithModel
  extend Roseflow::Action

  expects :prompt
  expects :model

  promises :response

  executed do |ctx|
    chat = ctx.model.chat(ctx.prompt)
    context[:response] = chat.response
  end
end