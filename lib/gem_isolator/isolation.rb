# frozen_string_literal: true

# Show warnings about vulnerabilities, bugs and outdated Rubies, since previous
# versions aren't tested or officially supported.
require 'ruby_dep/warning'
RubyDep::Warning.new.show_warnings

require 'gem_isolator/isolation/environment'
require 'gem_isolator/isolation/sandbox'

module GemIsolator
  # Main class for setting up sandbox/isolation environment
  class Isolation
    def initialize(options)
      gem_defs = options.fetch(:gems, [[]])
      within_sandbox do
        @sandbox = Sandbox.new(gems: gem_defs)
        sandbox.setup
        environment = Environment.new(gem_home: sandbox.gem_home).to_hash
        yield(environment, self)
      end
    end

    def system(*args)
      sandbox.system(*args)
    end

    private

    attr_reader :sandbox

    def within_sandbox
      Bundler.with_clean_env do
        Dir.mktmpdir do |path|
          Dir.chdir(path) do
            yield
          end
        end
      end
    end
  end
end
