# frozen_string_literal: true

require "phlex"
require "roseflow/prompt"

module Roseflow
  class SimplePrompt < Prompt
    def template
      plain "Hello, AI!"
    end
  end

  class VariablePrompt < Prompt
    def initialize(name:)
      @name = name
    end

    def template
      plain "Hello, #{@name}!"
    end
  end

  class NestedPromptTemplate < Prompt
    def template
      plain "Instructions: Respond to my commands. "
    end
  end

  class PromptWithNestedPrompt < Prompt
    def initialize(name:)
      @name = name
    end

    def template
      render NestedPromptTemplate
      plain "Hello, #{@name}!"
    end
  end

  class NestedPromptWithVariableTemplate < Prompt
    def initialize(persona:)
      @persona = persona
    end

    def template
      plain "Instructions: Respond to my commands as #{@persona}. "
    end
  end

  class PromptWithNestedPromptWithVariables < Prompt
    def initialize(name:, persona:)
      @name = name
      @persona = persona
    end

    def template
      render NestedPromptWithVariableTemplate.new(persona: @persona)
      plain "Hello, #{@name}!"
    end
  end
end
