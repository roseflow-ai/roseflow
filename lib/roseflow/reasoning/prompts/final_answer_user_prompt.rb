# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class FinalAnswerUserPrompt < Roseflow::Prompt
        def initialize(points)
          @points = points
        end

        def template
          plain_raw @points.map(&:to_s).join("\n")
        end
      end
    end
  end
end
