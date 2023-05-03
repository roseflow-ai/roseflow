# frozen_string_literal: true

require "roseflow/prompt"

class GithubChatPrompt < Roseflow::Prompt
  def initialize(input)
    @input = input
  end

  attr_reader :input

  def template
    plain_raw condensed(prompt_string)
  end

  private

  def prompt_string
    <<-PROMPT

    Command: [#{input}]
    PROMPT
  end
end
