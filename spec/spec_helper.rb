# frozen_string_literal: true
require 'nenv'
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run focus: !Nenv.ci?
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 2

  config.order = :random

  Kernel.srand config.seed

  config.before do
    allow(Kernel).to receive(:system) do |*args|
      raise "stub called: Kernel.system(#{args.map(&:inspect).join(', ')})"
    end

    allow(Object).to receive(:system) do |*args|
      raise "stub called: Object.system(#{args.map(&:inspect).join(', ')})"
    end

    allow(IO).to receive(:write) do |*args|
      raise "stub called: IO.write(#{args.map(&:inspect).join(', ')})"
    end

    allow_any_instance_of(Pathname).to receive(:write) do |*args|
      raise "stub called: Pathname#write(#{args.map(&:inspect).join(', ')})"
    end
  end
end
