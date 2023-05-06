# frozen_string_literal: true

require "roseflow/chat/exchange"
require "roseflow/chat/message"

module Roseflow
  module Chat
    class Dialogue
      attr_reader :messages
      attr_reader :exchanges
      attr_reader :personality

      def initialize(personality: nil)
        @messages = []
        @exchanges = []
        initialize_with_personality(personality) if personality
      end

      def model
        @model ||= provider.models.chattable.first
      end

      def provider
        @provider ||= OpenAI::Provider.new(Roseflow::OpenAI::Config.new)
      end

      def recall(messages)
        @messages = messages
        parse_exchanges
      end

      # This method takes a string input as input, which is a message to send to the LLM model.
      # If the model is chattable, it sends the messages to the model and returns a response.
      def say(input, **options)
        if model.chattable?
          message = create_user_message(input)
          @messages.push(message)

          model_response = provider.chat(model: model, messages: @messages, **options)

          if model_response && model_response.success?
            exchange = create_exchange(message, model_response.choices.first.message)
            @exchanges.push(exchange)
            @messages.push(exchange.response)
            exchange.response
          else
            raise "Did not receive a response from the model"
          end
        else
          raise "Model is not chattable"
        end
      end

      private

      def initialize_with_personality(personality)
        @personality = personality
        @messages << SystemMessage.new(role: "system", content: personality.description)
      end

      def create_user_message(input)
        UserMessage.new(role: "user", content: input)
      end

      def create_exchange(prompt, response)
        Exchange.new(prompt: prompt, response: response)
      end

      def parse_exchanges
        user_assistant_messages.each_cons(2) do |prompt, response|
          @exchanges << Exchange.new(prompt: prompt, response: response)
        end
      end

      def user_assistant_messages
        @messages.reject { |message| message.role == "system" }
      end
    end
  end
end
