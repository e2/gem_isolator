[![Gem Version](https://badge.fury.io/rb/gem_isolator.png)](http://badge.fury.io/rb/gem_isolator) [![Build Status](https://secure.travis-ci.org/e2/gem_isolator.png?branch=master)](http://travis-ci.org/e2/gem_isolator) 

# GemIsolator

Allows running commands in an isolated set of gems.

Useful for testing gem dependencies in your project and reproducing related bugs.

NOTE: It currently requires Bundler to setup the isolated environment, but
Bundler isn't necessary to run your Ruby code in isolation.

## Requirements

For supported Ruby versions, check the .travis.yml file.

(For supporting older versions, open an issue - with some info about why you are unable to upgrade).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gem_isolator'
```

And then execute:

    $ bundle

## Usage

E.g. in an RSpec test:

```ruby
cmd = "ruby #{File.expand_path('lib/foo.rb')}"
GemIsolator.isolate(gems: [%w(bar >=3.2.1)]) do |env, isolation|
  expect(isolation.system(env, cmd)).to eq(true)
end
```

1. `lib/foo.rb` is relative to your project's current directory.
2. `system` acts just like `Kernel.system`.
3. You can pass custom environment variables, e.g `env.merge('FOO' => '1')`
4. `:gems` is a list of gems you want installed

## Features

- [x] sets up temp dir with bundled gems
- [x] allows defining which gems you need installed in the sandbox
- [x] allows overriding environment
- [x] allows running commands via Bundler or plain RubyGems
- [x] allows multiple commands within same sandbox
- [x] fails if sandbox can't be initialized
- [ ] seemlessly allows you to run same tests using Docker
- [ ] smart caching and/or proxy for faster gem installations
- [ ] allows reusing same sandbox object between tests
- [ ] release a 1.x as soon as API is useful and comfortable enough

## Things to be careful about

You can run commands in 3 ways:

1. `system('foo')` will search for 'foo' among the binaries of installed isolated gems first
2. `system('bin/foo')` a binstubbed version of binary from isolated gems (uses Bundler)
3. `system('bundle exec foo')` uses Bundler instead of RubyGems

Capturing output is not yet supported (open a PR if you're interested).

NOTE: Inside the block, the current directory is set to a temporary directory,
so it's best to expand your paths outside the block.

NOTE: You might prefer to use caching, by e.g. setting a gem source or proxy.
Open a feature request if you're interested in something automatic/generic.

NOTE: `:gems` option is an array (for each gem) of arrays (Gemfile `gem` keyword arguments). `.inspect` is used to stringify, so things should work as expected, even if you use a hash.


## Debugging

Just use system() commands to find out what's going on, e.g.:

```ruby
cmd = "ruby #{File.expand_path('lib/foo.rb')}"
GemIsolator.isolate(gems: [%w(bar ~>1.2)]) do |env, isolation|
  # debugging
  isolation.system("pwd")
  isolation.system("gem env")
  isolation.system("gem list")
  isolation.system("cat Gemfile")
  isolation.system("cat Gemfile.lock")
  isolatior.system("ls -l")
  isolatior.system("find bundle -name 'foo'")

  expect(isolation.system(env, cmd)).to eq(true)
end
```

## Development

Run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/e2/gem_isolator.

If there are no other major open pull requests (or active branches), feel free to refactor/reorganize the project as you like.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
