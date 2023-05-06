require "spec_helper"

require "roseflow/chat/dialogue"
require "roseflow/chat/personality"
require "roseflow/chat/message"

VCR.configure do |config|
  config.filter_sensitive_data("<OPENAI_KEY>") { Roseflow::OpenAI::Config.new.api_key }
  config.filter_sensitive_data("<OPENAI_ORGANIZATION_ID>") { Roseflow::OpenAI::Config.new.organization_id }
end

module Roseflow
  module Chat
    RSpec.describe Dialogue do
      let(:dialogue) { described_class.new }

      describe "#say" do
        it "sends a message to the model" do
          VCR.use_cassette("openai/hello", record: :new_episodes) do
            expect(dialogue.say("Hello")).to be_truthy
          end
        end
      end

      describe "#messages" do
        it "returns a list of messages" do
          expect(dialogue.messages).to be_a Array
        end

        context "when a message is added" do
          let(:message) { Message.new(role: "user", content: "Hello!") }

          before do
            VCR.use_cassette("openai/hello", record: :new_episodes) do
              dialogue.say("Hello!")
            end
          end

          it "returns a list of messages" do
            expect(dialogue.messages).to include message
          end
        end

        context "when a dialogue is recalled" do
          let(:message) { Message.new(role: "system", content: "Hello!") }
          let(:message_1) { Message.new(role: "user", content: "Hello, model!") }
          let(:message_2) { Message.new(role: "assistant", content: "Hello, user!") }

          before do
            dialogue.recall([message, message_1, message_2])
          end

          it "returns a list of messages" do
            expect(dialogue.messages).to eq [message, message_1, message_2]
            expect(dialogue.exchanges.count).to eq 1
          end

          describe "continuing the dialogue" do
            before do
              VCR.use_cassette("openai/exchange", record: :new_episodes) do
                dialogue.say("Who won the World Cup in 1990?")
              end
            end

            it "has more than one exchange" do
              expect(dialogue.exchanges.count).to eq 2
              puts dialogue.exchanges.last.prompt.content
              puts dialogue.exchanges.last.response.content
            end

            it "remembers the context" do
              VCR.use_cassette("openai/exchange/with_context", record: :new_episodes) do
                dialogue.say("Who was the goalkeeper for the winning team?")
                expect(dialogue.exchanges.count).to eq 3
                puts dialogue.exchanges.last.prompt.content
                puts dialogue.exchanges.last.response.content
              end
            end
          end
        end
      end

      describe "Personalities" do
        context "helpful assistant" do
          let(:personality) { Personality.new(name: "assistant", description: "You are a helpful assistant.") }
          let(:dialogue) { described_class.new(personality: personality) }

          it "has a personality" do
            expect(dialogue.personality.name).to eq "assistant"
            expect(dialogue.messages.count).to eq 1
            expect(dialogue.messages.first).to be_a SystemMessage
          end

          describe "#say" do
            before do
              VCR.use_cassette("openai/chat/personality", record: :new_episodes) do
                dialogue.say("Hello, who are you?")
              end
            end

            it "sends a message to the model" do
              expect(dialogue.messages.count).to eq 3
              expect(dialogue.messages.last.role).to eq "assistant"
            end
          end
        end

        context "expert in football history" do
          let(:personality) { Personality.new(name: "football-expert", description: "You are an expert in soccer history. You are proficient with all the leagues, teams, players and matches throughout the history of soccer.") }
          let(:dialogue) { described_class.new(personality: personality) }

          before do
            VCR.use_cassette("openai/chat/personality/football_expert", record: :new_episodes) do
              dialogue.say("What's your current role or persona? Any sports where you are an expert in?")
            end
          end

          it "has a personality" do
            pp dialogue.exchanges.last.response.content
            expect(dialogue.exchanges.last.response.content).to match /soccer/
          end
        end
      end
    end
  end
end
