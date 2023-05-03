# frozen_string_literal: true

require "phlex"

module Roseflow
  class Prompt < Phlex::SGML
    private

    def plain_raw(content)
      unsafe_raw(content)
    end

    def condensed(string)
      string.gsub(/\s+/, " ").strip
    end
  end
end
