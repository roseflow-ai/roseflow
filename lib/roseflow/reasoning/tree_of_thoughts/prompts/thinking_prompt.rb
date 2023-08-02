# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class ThinkingPrompt < Roseflow::Prompt
        def initialize(initial:, state:, rejected: [], react: false)
          @initial_prompt = initial
          @state_as_text = state
          @rejected_solutions = rejected
          @react = react
        end

        def react_prompting?
          !!@react
        end

        def template
          plain_raw(predirective)
          plain_raw(reasoning) if @state_as_text.present?
          plain_raw(directive)
          plain_raw(rejected_solutions) if @rejected_solutions.any?
          plain_raw(no_rejected_solutions) unless @rejected_solutions.any?
          plain_raw(post_directive)
          plain_raw(react_prompt_string) if react_prompting?
        end

        def predirective
          <<-PROMPT
            You're a superintelligent AI called Deep Thought, devoted to helping Humans by any means necessary.
            Your purpose is to generate a series of solutions to comply with the user's instructions. You must
            generate solutions on the basis of determining the most reliable solution in the shortest amount of time,
            while taking rejected solutions into account and learning from them. 
          PROMPT
        end

        def reasoning
          <<-PROMPT
            Considering the reasoning provided:
            <REASONING>
            #{@state_as_text}
            </REASONING>
          PROMPT
        end

        def directive
          <<-PROMPT
            Devise the best possible solution for the task:
            <TASK>
            #{@initial_prompt}
            </TASK>
          PROMPT
        end

        def rejected_solutions
          <<-PROMPT
            Here are evaluated solutions that were rejected: 
            <REJECTED_SOLUTIONS>
            #{@rejected_solutions}
            </REJECTED_SOLUTIONS>
          PROMPT
        end

        def no_rejected_solutions
          <<-PROMPT
            No solutions have yet been generated and rejected.
          PROMPT
        end

        def post_directive
          <<-PROMPT
            Complete the "#{@initial_prompt}" without making the same mistakes you did with the evaluated rejected
            solutions. Be simple. Be direct. Provide intuitive solutions as soon as you think of them.
          PROMPT
        end

        def react_prompt_string
          <<-PROMPT
            Write down your observations in format '[Observation]:xxxx',
            then write down your thoughts in format '[Thoughts]:xxxx'.
          PROMPT
        end
      end
    end
  end
end
