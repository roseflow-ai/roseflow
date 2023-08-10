# frozen_string_literal: true

module Roseflow
  module Action
    # This module is used to define the CLI interface for an interaction
    module WithEvents
      def self.extended(base_class)
        base_class.extend ClassMethods
      end

      module ClassMethods
        def bus=(bus)
          @bus = bus
        end

        def bus
          @bus ||= Registry.get(:events)
        end
      end
    end
  end
end
