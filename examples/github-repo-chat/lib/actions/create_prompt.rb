# frozen_string_literal: true

require "roseflow/action"
require_relative "../github_chat_prompt"

class Actions::CreatePrompt
  extend Roseflow::Action

  expects :input
  promises :prompt

  executed do |ctx|
    ctx[:prompt] = GithubChatPrompt.new(input)
  end
end