# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in gem_isolator.gemspec
gemspec development_group: :gem_tools

group :gem_tools do
end

group :test do
  gem 'rspec', '~>3.4'
  gem 'nenv'
end

group :development do
  gem 'guard', '~>2.14'
  gem 'guard-rspec', '~>4.7'
  gem 'guard-rubocop', '~>1.2'
  gem 'guard-bundler', '~> 2.1'
end
