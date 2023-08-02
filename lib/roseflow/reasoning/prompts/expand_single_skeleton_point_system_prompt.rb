# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class ExpandSingleSkeletonPointSystemPrompt < Roseflow::Prompt
        def initialize(skeleton, prompt)
          @skeleton = skeleton
          @prompt = prompt
        end

        def template
          plain_raw predirective
          plain_raw prompt_string(@prompt)
          plain_raw skeleton_string(@skeleton)
        end

        def predirective
          <<-PROMPT
            You are responsible for continuing the writing of one and only one point in the overall answer
            to the following question.
          PROMPT
        end

        def prompt_string(prompt)
          <<-PROMPT
            The question is:
            <QUESTION>
            #{prompt}
            </QUESTION>
          PROMPT
        end

        def skeleton_string(skeleton)
          <<-PROMPT
            The skeleton of the answer is:
            <SKELETON>
            #{skeleton}
            </SKELETON>
          PROMPT
        end
      end
    end
  end
end
