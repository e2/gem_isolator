# frozen_string_literal: true
module GemIsolator
  class Isolation
    # Creates a Gemfile
    class Gemfile
      def initialize(options)
        gem_defs = options.fetch(:gems)
        @content = generate(gem_defs)
      end

      def create
        IO.write('Gemfile', @content)
      end

      private

      def generate(gem_defs)
        content = "source 'https://rubygems.org';\n"
        gem_defs.each do |requirements|
          content += "gem #{requirements.map(&:inspect).join(', ')};\n"
        end
        content
      end
    end
  end
end
