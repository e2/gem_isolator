# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_isolator/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_isolator'
  spec.version       = GemIsolator::VERSION
  spec.authors       = ['Cezary Baginski']
  spec.email         = ['cezary@chronomantic.net']

  spec.summary       = 'Use an isolated set of gems in your tests'
  spec.description   = 'Good for testing dependencies of a gem and/or'\
    ' different gem version combinations'
  spec.homepage      = 'https://github.com/e2/gem_isolator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(lib/|README.md|LICENSE.txt)})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nenv', '~> 0.3'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'

  begin
    require 'ruby_dep/travis'
    spec.required_ruby_version = RubyDep::Travis.new.version_constraint
  rescue LoadError
    # TODO: fall back to using a vendored version?
    abort "Install 'ruby_dep' gem before building this gem"
  end

  # Used to show warnings at runtime
  spec.add_dependency 'ruby_dep', '~> 1.3', '>= 1.3.1'
end
