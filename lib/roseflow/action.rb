# frozen_string_literal: true

require "light-service"

module Roseflow
  module Action
    extend LightService::Action

    def self.extended(base_class)
      base_class.extend LightService::Action::Macros
    end
  end
end
