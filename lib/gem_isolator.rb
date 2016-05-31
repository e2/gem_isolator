# frozen_string_literal: true
require 'gem_isolator/version'
require 'gem_isolator/isolation'

# Namespace
module GemIsolator
  def self.isolate(options, &block)
    Isolation.new(options, &block)
  end
end
