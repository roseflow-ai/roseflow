# frozen_string_literal: true

module Roseflow
  class Tokenizer
    def encode(input)
      raise NotImplementedError, "this class must be extended and the #encode method implemented"
    end

    def decode(input)
      raise NotImplementedError, "this class must be extended and the #decode method implemented"
    end
  end
end
