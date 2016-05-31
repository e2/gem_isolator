# frozen_string_literal: true
source 'https://rubygems.org'

if ENV['SKIP_GEMFILE_DEPS'] == '1'
  gem 'bundler', '~> 1.12'
  gem 'rake', '~> 11.1'
  gem 'ruby_dep', '~> 1.3', '>= 1.3.1'
else
  gemspec development_group: :gem_tools
end

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
