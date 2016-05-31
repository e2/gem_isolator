# frozen_string_literal: true
module GemIsolator
  class Isolation
    # RubyGems isolating environment
    class Environment
      def initialize(options)
        @gem_home = options.fetch(:gem_home)
      end

      def to_hash
        @environment ||= {
          'GEM_HOME' => gem_home.to_s,
          'GEM_PATH' => gem_home.to_s,
          'PATH' => "#{bin_path}:#{ENV['PATH']}"
        }.freeze
      end

      private

      attr_reader :gem_home

      def bin_path
        @bin_path ||= gem_home + 'gems/bin'
      end
    end
  end
end
