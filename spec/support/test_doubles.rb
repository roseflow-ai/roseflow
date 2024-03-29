# frozen_string_literal: true

# A collection of Interaction dummies for specs

require "spec_helper"
require "roseflow/action"
require "roseflow/action/with_events"
require "roseflow/interaction"
require "omnes"

module TestDoubles
  class AnInferenceAction
    extend Roseflow::Action
  end

  class DataLoadingAction
    extend Roseflow::Action
  end

  class SimpleInteraction
    extend Roseflow::Interaction

    def self.call(interaction_arguments)
      with(interaction_arguments).reduce([DataLoadingAction, AnInferenceAction])
    end

    def self.perform_without_actions(interaction_arguments)
      with(interaction_arguments).reduce
    end

    def self.call_without_starting_context(interaction_arguments)
      reduce([DataLoadingAction, AnInferenceAction])
    end
  end

  class NotExplicitlyReturningContextInteraction
    extend Roseflow::Interaction

    def self.call(context)
      context[:foo] = [1, 2, 3]
    end
  end

  class NestingInteraction
    extend Roseflow::Interaction

    def self.call(context)
      with(context).reduce(actions)
    end

    def self.actions
      [
        NotExplicitlyReturningContextInteraction, NestedAction
      ]
    end
  end

  class NestedAction
    extend Roseflow::Action

    expects :foo

    executed do |context|
      context[:bar] = context.foo
    end
  end

  class AnInteractionThatAddsToContext
    extend Roseflow::Interaction

    def self.call
      with.reduce(actions)
    end

    def self.actions
      [
        add_to_context(
          strongest_avenger: "Thor",
          last_jedi: "Rey"
        )
      ]
    end
  end

  class AnInteractionThatAddsAliases
    extend Roseflow::Interaction

    def self.call
      with(foo: :bar).reduce(actions)
    end

    def self.actions
      [
        add_aliases(foo: :baz)
      ]
    end
  end

  class AddsToActionWithFetch
    extend Roseflow::Action

    executed do |context|
      number = context.fetch(:number, 0)
      context[:number] = number + 2
    end
  end

  class EventedAction
    extend Roseflow::Action
    extend Roseflow::Action::WithEvents

    executed do |context|
      bus.publish(:action_event, name: "foo")
    end
  end

  class ActionEventSubscriber
    include Omnes::Subscriber

    handle :action_event, with: :handler

    def handler(event)
      puts "RECEIVED EVENT: #{event.payload.fetch(:name)}"
    end
  end

  class ApiUsageEventSubscriber
    include Omnes::Subscriber

    handle :api_usage_event, with: :handler

    def handler(event)
      puts "RECEIVED API USAGE: #{event.payload.fetch(:usage)}"
    end
  end

  class StreamingEventSubscriber
    include Omnes::Subscriber

    handle :model_streaming_event, with: :handler

    def handler(event)
      puts "RECEIVED STREAMING EVENT for #{event.stream_id}: #{event.body}"
    end
  end
end
