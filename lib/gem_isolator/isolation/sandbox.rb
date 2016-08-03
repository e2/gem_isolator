# frozen_string_literal: true
require 'gem_isolator/isolation/gemfile'

module GemIsolator
  class Isolation
    # Class for installing gems into the sandbox in the current directory
    class Sandbox
      class Error < RuntimeError
        class BundlerFailed < Error; end
      end

      def initialize(options)
        @gem_defs = options.fetch(:gems)
      end

      def setup
        Gemfile.new(gems: @gem_defs).create
        case Kernel.system(*%w(bundle install --standalone --binstubs))
        when false
          raise Error::BundlerFailed, 'sandbox setup with bundler failed'
        when nil
          raise Errno::ENOENT, "cannot run command 'bundle'"
        end
      end

      def gem_home
        @gem_home ||= gem_base_path + ruby_dir
      end

      def system(*args)
        Kernel.system(*args)
      end

      private

      def gem_base_path
        @gem_base_path ||= Pathname.pwd + "bundle/#{RUBY_ENGINE}"
      end

      def ruby_dir
        subdirs = gem_base_path.children
        unknown_dirs = subdirs[1..-1]
        return subdirs.first if unknown_dirs.empty?
        raise ArgumentError, "Unknown gem home subdirs: #{unknown_dirs.inspect}"
      end
    end
  end
end
