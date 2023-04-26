# frozen_string_literal: true

require "light-service/context"
require "hashie/extensions/method_access"

module Roseflow
  class InteractionContext < LightService::Context
    include Hashie::Extensions::MethodAccess
  end
end