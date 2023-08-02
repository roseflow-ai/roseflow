# frozen_string_literal: true

module Roseflow
  module Interaction
    # This module is used to define the documentation for an interaction
    module WithDocumentation
      def self.extended(base_class)
        base_class.extend ClassMethods
      end

      module ClassMethods
        def documentation(&block)
          documentation_proxy = DocumentationProxy.new
          documentation_proxy.instance_eval(&block)
        end
      end

      class DocumentationProxy
        # Defines a description for the interaction
        def description(description)
        end

        # Defines a list of input parameters for the interaction
        # @param key [Symbol] the name of the parameter
        # @param description [String] the description of the parameter
        def expects(key, description = "")
        end

        # Defines a list of output parameters for the interaction
        # @param key [Symbol] the name of the parameter
        # @param description [String] the description of the parameter
        def promises(key, description = "")
        end
      end
    end
  end
end
