# frozen_string_literal: true

require "spec_helper"
require "roseflow/ai/model"

module Roseflow
  module AI
    RSpec.describe Model do
      describe "#initialize" do
        let(:model) { described_class.new(name: "gpt-3.5-turbo") }

        it "creates a new instance of Model" do
          VCR.use_cassette("ai/model/initialize") do
            expect(model).to be_a(Model)
            expect(model.name).to eq "gpt-3.5-turbo"
            expect(model.provider).to eq :openai
            expect(model.config).to be_a(Models::Configuration)
          end
        end

        it "raises an error if the model does not exist" do
          expect { described_class.new(name: "foobar-turbo") }.to raise_error(ModelRepository::ModelNotFoundError)
        end

        it "raises an error if the model name is not provided" do
          expect { described_class.new }.to raise_error(ArgumentError).with_message("Name must be provided")
        end
      end

      describe "configuration" do
        let(:model) { described_class.new(name: "gpt-3.5-turbo") }

        it "has a configuration" do
          VCR.use_cassette("ai/model/initialize") do
            expect(model).to be_a(Model)
            config = model.config
            expect(config.max_tokens).to eq 2048
          end
        end
      end

      describe "#operations" do
        it "returns a list of operations" do
          VCR.use_cassette("ai/model/operations") do
            model = described_class.new(name: "gpt-3.5-turbo")
            expect(model).to be_a(Model)
            expect(model).to respond_to(:operations)
            expect(model.operations).to be_a(Array)
          end
        end
      end

      describe "SSE events" do
        before do
          Registry.get(:events).register(:model_streaming_event)
        end

        let(:model) { Registry.get(:models).find("gpt-3.5-turbo") }
        let(:config) { Models::Configuration.new(stream_events: true) }
        let(:messages) {
          [
            Roseflow::Chat::Message.new(role: "system", content: "Count from 1 to 5.")
          ]
        }
        let(:subscriber) { TestDoubles::StreamingEventSubscriber.new }

        it "publishes streaming SSE events" do
          subscriber.subscribe_to(Registry.get(:events))

          VCR.use_cassette("ai/model/streaming", record: :new_episodes) do
            model.config = config
            expect(model.config.stream_events).to be_truthy
            expect(model.chat(model: model.name, messages: messages, stream: true, stream_events: true)).to be_success
          end
        end
      end

      describe "API usage" do
        before do
          Registry.get(:events).register(:api_usage_event)
        end

        let(:model) { Registry.get(:models).find("gpt-3.5-turbo") }
        let(:config) { Models::Configuration.new(instrumentation: true) }
        let(:messages) {
          [
            Roseflow::Chat::Message.new(role: "system", content: "Count from 1 to 5.")
          ]
        }
        let(:subscriber) { TestDoubles::ApiUsageEventSubscriber.new }

        it "publishes API usage" do
          subscriber.subscribe_to(Registry.get(:events))

          VCR.use_cassette("ai/model/api_usage") do
            model.config = config
            expect(model.config.instrumentation).to be_truthy
            expect(model.chat(model: model.name, messages: messages)).to be_success
          end
        end
      end
    end
  end # AI
end # Roseflow
