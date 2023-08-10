# frozen_string_literal: true

require "spec_helper"
require "roseflow/registry"

module Roseflow
  RSpec.describe Registry do
    describe "Initialization" do
      subject { described_class.instance }

      it "can be initialized" do
        expect(subject).to be_a described_class
      end
    end

    describe "registering" do      
      subject { described_class.instance }

      it "registers a value with a key" do
        expect(subject.register(:foo, :bar)).to be_truthy
        expect(subject.get(:foo)).to eq :bar        
      end

      it "registered key shows up in keys" do
        expect(subject.keys).to include(:foo)
      end
    end
  end
end