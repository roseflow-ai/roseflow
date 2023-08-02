# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class FinalAnswerSystemPrompt < Roseflow::Prompt
        def initialize(question, provider = :openai)
          @question = question
          @provider = provider
        end

        def template
          plain_raw directive
        end

        def directive
          case @provider
          when :openai
            openai_directive
          when :anthropic
            anthropic_directive
          end
        end

        def openai_directive
          <<-PROMPT
            You are an expert writer, responsible for writing the final, comprehensive answer to the following question.

            <QUESTION>
            #{@question}
            </QUESTION>

            The user will provide a list of points that should guide your writing. Carefully consider all points
            provided when formulating your answer.
          PROMPT
        end

        def anthropic_directive
          <<-PROMPT
            Human: You are an expert writer, responsible for writing the final, comprehensive answer to the following question.

            <question>
            #{@question}
            </question>

            The user will provide a list of points that should guide your writing. Carefully consider all points
            provided when formulating your answer.

            When you reply, write your answer inside <answer></answer> XML tags.
          PROMPT
        end
      end
    end
  end
end
