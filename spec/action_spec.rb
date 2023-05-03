# frozen_string_literal: true

require "spec_helper"

module Roseflow
  RSpec.describe Action do
    let(:ctx) { Roseflow::InteractionContext.make }

    context "when the action context has failure" do
      it "returns immediately" do
        ctx.fail!("Something went wrong")

        TestDoubles::AddsToActionWithFetch.execute(ctx)

        expect(ctx.to_hash.keys).to be_empty
      end

      it "returns a failure message in the context" do
        ctx.fail!("Something went wrong")

        returned_ctx = TestDoubles::AddsToActionWithFetch.execute(ctx)

        expect(returned_ctx.message).to eq "Something went wrong"
      end
    end

    context "when the action has an explicit success message" do
      it "returns the success message" do
        ctx.succeed!("Everything went well")

        returned_ctx = TestDoubles::AddsToActionWithFetch.execute(ctx)

        expect(returned_ctx.message).to eq "Everything went well"
      end
    end

    context "when the action context does not have a failure" do
      it "executes the block" do
        TestDoubles::AddsToActionWithFetch.execute(ctx)
        expect(ctx.to_hash.keys).to eq [:number]
        expect(ctx.fetch(:number)).to eq 2
        expect(ctx.number).to eq 2
      end
    end

    context "when the action context skips all" do
      it "returns immediately" do
        ctx.skip_remaining!

        TestDoubles::AddsToActionWithFetch.execute(ctx)

        expect(ctx.to_hash.keys).to be_empty
        expect(ctx).to be_success
      end

      it "does not execute skipped actions" do
        TestDoubles::AddsToActionWithFetch.execute(ctx)
        expect(ctx.number).to eq 2

        ctx.skip_remaining!

        TestDoubles::AddsToActionWithFetch.execute(ctx)
        expect(ctx.number).to eq 2
      end
    end

    it "returns the context" do
      result = TestDoubles::AddsToActionWithFetch.execute(ctx)
      expect(result.number).to eq 2
    end

    context "when called directly" do
      it "is expected not to be organized" do
        result = TestDoubles::AddsToActionWithFetch.execute(ctx)
        expect(result.organized_by).to be_nil
      end
    end
  end
end
