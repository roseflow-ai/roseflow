# frozen_string_literal: true

require "spec_helper"
require "roseflow/event_bus"

module Roseflow
  RSpec.describe EventBus do
    subject { described_class.new }

    it "does not share buses between instances" do
      klass = described_class.new
      
      expect(klass.omnes_bus).not_to be(subject.omnes_bus)
    end

    describe "events" do
      describe "from actions" do
        before do
          Registry.get(:events).register(:action_event)
        end

        let(:action) { TestDoubles::EventedAction.execute }
        let(:subscriber) { TestDoubles::ActionEventSubscriber.new }

        it "receives events from actions" do
          expect(subscriber).to receive(:handler)
          subscriber.subscribe_to(Registry.get(:events))
          expect(action).to be_success
        end
      end
    end
  end
end