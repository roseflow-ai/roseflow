# frozen_string_literal: true

# This class represents an action that interacts with a given model using a
# provided prompt. The action expects both a prompt and a model as input, and
# returns a response generated by the model.
#
# Example usage:
#   response = Actions::InteractWithModel.execute(prompt: "What is the capital of France?", model: my_model)

require "roseflow/action"

class Actions::InteractWithModel
  # Make it a Roseflow action
  extend Roseflow::Action

  # Define the inputs and outputs of the action
  expects :prompt # Input: The prompt to use
  expects :model # Input: The model to interact with

  promises :response # Output: The response generated by the model

  executed do |ctx|
    # Interact with the model using the provided prompt
    chat = ctx.model.chat(ctx.prompt)

    # Store the response in the context
    context[:response] = chat.response
  end
end
