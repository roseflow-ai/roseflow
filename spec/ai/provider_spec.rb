# frozen_string_literal: true

require "spec_helper"

module Roseflow
  module AI
    RSpec.describe Provider do
      let(:config) { PROVIDER_GEMS.fetch(:"roseflow-openai") }

      describe "#initialize" do
        let(:provider) { described_class.new(name: :openai, config: config) }

        it "creates an instance of the provider" do
          expect(provider).to be_a(Provider)
          expect(provider.name).to eq :openai
        end

        it "implements the adapter interface" do
          expect(provider.send(:instance)).to be_a(ProviderInterface)
        end

        it "raises an error if provider is not supported" do
          expect { Provider.new(name: :not_supported, config: {}) }.to raise_error(NotImplementedError)
        end
      end

      describe "models" do
        let(:provider) { described_class.new(name: :openai, config: config) }

        it "returns a list of models" do
          VCR.use_cassette("ai/provider/models") do
            expect(provider).to respond_to(:models)
            expect(provider.models).to be_a(OpenAI::ModelRepository)
          end
        end
      end
    end
  end
end
