# frozen_string_literal: true

require "roseflow/reasoning/skeleton_point"

module Roseflow
  module Reasoning
    module Actions
      class AddPointsToContext
        extend Roseflow::Action

        expects :skeleton

        executed do |ctx|
          json = JSON.parse(ctx.skeleton)
          ctx[:points] = json["skeleton"].map { |point| SkeletonPoint.new(point) }
        rescue JSON::ParserError
          ctx.fail!
        end
      end
    end
  end
end
