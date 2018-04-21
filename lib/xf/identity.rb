# frozen_string_literal: true

module Xf
  # Gem identity information.
  module Identity
    def self.name
      "xf"
    end

    def self.label
      "Xf"
    end

    def self.version
      "0.0.1"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
