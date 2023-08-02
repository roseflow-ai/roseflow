# frozen_string_literal: true

module Roseflow
  module Reasoning
    module Prompts
      class ExpandSingleSkeletonPointUserPrompt < Roseflow::Prompt
        def initialize(point)
          @point = point
        end

        def template
          plain_raw predirective
          plain_raw point_string(@point)
          plain_raw json_schema
        end

        def predirective
          # <<-PROMPT
          #   Continue and only continue the writing of point #{@point.order}. Write it **very shortly**
          #   in a few sentences and do not continue with other points.
          # PROMPT
          <<-PROMPT
            Continue and only continue the writing of point #{@point.order}. Write it succinctly
            in a few sentences and do not continue with other points.
          PROMPT
        end

        def point_string(point)
          <<-PROMPT
            <POINT>
            #{point.to_s}
            </POINT>
          PROMPT
        end

        def json_schema
          <<-SCHEMA
            Return your answer using the following JSON schema.
            <SCHEMA>
            #{schema.to_json}
            </SCHEMA>
          SCHEMA
        end

        def schema
          {
            "$schema": "http://json-schema.org/draft-07/schema#",
            "type": "object",
            "properties": {
              "order": {
                "type": "integer",
                "minimum": 1,
                "maximum": 10,
              },
              "text": {
                "type": "string",
              },
            },
            "required": ["order", "text"],
          }
        end
      end
    end
  end
end
