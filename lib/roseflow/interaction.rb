# frozen_string_literal: true

require "light-service"

module Roseflow
  module Interaction
    extend LightService::Organizer

    def self.extended(base_class)
      base_class.extend LightService::Organizer::ClassMethods
      base_class.extend LightService::Organizer::Macros
    end
  end
end
