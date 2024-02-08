# frozen_string_literal: true

require "spec_helper"

require "roseflow/chat/message"

module Roseflow
  module Chat
    RSpec.describe Message do
      describe "System messages" do
        describe ".from" do
          it "creates a system message from a string" do
            message = SystemMessage.from("Hello, AI!")
            expect(message.content).to eq "Hello, AI!"
            expect(message.role).to eq "system"
          end

          it "creates a system message from a prompt" do
            prompt = SimplePrompt.new
            message = SystemMessage.from(prompt)
            expect(message.content).to eq "Hello, AI!"
            expect(message.role).to eq "system"
          end
        end
      end

      describe "User messages" do
        describe ".from" do
          it "creates a user message from a string" do
            message = UserMessage.from("Hello, AI!")
            expect(message.content).to eq "Hello, AI!"
            expect(message.role).to eq "user"
          end

          it "creates a user message from a prompt" do
            prompt = SimplePrompt.new
            message = UserMessage.from(prompt)
            expect(message.content).to eq "Hello, AI!"
            expect(message.role).to eq "user"
          end
        end
      end
    end
  end
end