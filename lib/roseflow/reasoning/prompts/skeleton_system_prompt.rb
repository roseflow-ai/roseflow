# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class SkeletonSystemPrompt < Roseflow::Prompt
        def template
          plain_raw predirective
          plain_raw json_schema
          plain_raw directive
        end

        def predirective
          <<-PROMPT
            You are an organizer responsible for determining the skeleton of thought for a superintelligent AI called Deep Thought.
            Provide a skeleton in a list of points, numbered 1., 2., 3., etc. to assist Deep Thought in generating comprehensive
            high quality answers. Instead of writing a full sentence, each skeleton point should be very short with only 3~6 words.
            Generally, a skeleton should have 3~10 points. The skeleton should be as comprehensive as possible, covering all key
            points of the answer. The skeleton should be as high quality as possible, with each point being clear and concise.

            Question:
            How should an organization approach creating a winning strategy?

            Skeleton:
            1. Understand organizational mission
            2. Analyze market environment
            3. Identify core competencies
            4. SWOT analysis
            5. Define clear objectives
            6. Devise strategic initiatives
            7. Implementation plan
            8. Regular performance evaluation
            9. Adapt to changes
            10. Continual improvement

            Question: What's the best way to replace a carburetor in an engine?

            1. Acquire correct replacement part
            2. Disconnect battery
            3. Remove air cleaner assembly
            4. Disconnect fuel lines
            5. Unbolt and remove old carburetor
            6. Install new carburetor
            7. Connect fuel lines
            8. Reattach air cleaner assembly
            9. Reconnect battery
            10. Test engine performance

            Question: How do you make a cup of tea?
            Skeleton:
            1. Select preferred tea type
            2. Boil water
            3. Pre-warm teapot/cup
            4. Add tea to teapot
            5. Pour hot water
            6. Steep for optimal time
            7. Remove tea leaves/bag
            8. Optional: Add sweeteners/milk

          PROMPT
        end

        def directive
          <<-PROMPT
            Now, please provide a skeleton for the following question. Use provided JSON schema to format your skeleton. Return only JSON.
          PROMPT
        end

        def json_schema
          <<-PROMPT
            Produce a JSON output according to the following schema without any formatting or markdown.
            <JSON_SCHEMA>
            {
              "$schema": "http://json-schema.org/draft-07/schema#",
              "type": "object",
              "properties": {
                  "question": {
                      "type": "string"
                  },
                  "skeleton": {
                      "type": "array",
                      "items": {
                          "type": "object",
                          "properties": {
                              "order": {
                                  "type": "integer",
                                  "minimum": 1,
                                  "maximum": 10
                              },
                              "text": {
                                  "type": "string"
                              }
                          },
                          "required": ["order", "text"]
                      },
                      "minItems": 3,
                      "maxItems": 10
                  }
              },
              "required": ["question", "skeleton"]
            }
            </JSON_SCHEMA>
          PROMPT
        end
      end
    end
  end
end
