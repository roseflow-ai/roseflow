# frozen_string_literal: true

require "hashie/mash"
require "active_support/core_ext/module/delegation"

module Roseflow
  class ModelRepository
    class ModelNotFoundError < StandardError; end

    attr_reader :models

    def initialize
      @models = load_models
    end

    def all
      models
    end

    def find(name)
      result = models.find { |model| model.name == name }
      raise ModelNotFoundError, "Model #{name} not found" if result.nil?
      result
    end

    def list
      models.map(&:name)
    end

    private

    def load_models
      models = []
      providers = Registry.get(:providers).all
      providers.each do |provider|
        provider.models.each do |model|
          models << AI::Model.new(name: model.name, provider: provider)
        end
      end
      models
    end
  end
end
