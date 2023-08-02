# frozen_string_literal: true

module Roseflow
  module Interaction
    # This module is used to define the CLI interface for an interaction
    module WithCli
      def self.extended(base_class)
        base_class.extend ClassMethods
      end

      module ClassMethods
        def cli(&block)
          @cli_proxy = CliProxy.new
          @cli_proxy.instance_eval(&block)
        end

        def command
          return self.name if @cli_proxy.nil?
          @cli_proxy.command
        end
      end

      class CliProxy
        # Defines command name for interaction
        # @param [String] command_name
        def command(command = nil)
          return @command = command if command
          return @command if @command

          raise ArgumentError, "No command name provided"
        end
      end
    end
  end
end
