# frozen_string_literal: true

require_relative "roseflow/version"

require "roseflow/action"
require "roseflow/action/with_events"
require "roseflow/ai/model"
require "roseflow/ai/provider"
require "roseflow/chat/dialogue"
require "roseflow/finite_machine"
require "roseflow/interaction"
require "roseflow/interaction/with_cli"
require "roseflow/interaction/with_documentation"
require "roseflow/interaction_context"
require "roseflow/interactions/ai/initialize_llm"
require "roseflow/vector_stores/base"
require "roseflow/registry"

module Roseflow
  class Error < StandardError; end

  # Releasing the Kraken soon...
end
