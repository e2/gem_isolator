# frozen_string_literal: true
require 'gem_isolator/isolation'

RSpec.describe GemIsolator::Isolation do
  describe '#initialize' do
    context 'with valid arguments' do
      let(:options) { { gems: [['foo', '~> 1.2']] } }
      let(:gemfile_options) { { gems: [['foo', '~> 1.2']] } }
      let(:tmp_dir) { '/tmp/foo/bar' }
      let(:gem_home_path) { instance_double(Pathname, :gem_home_path) }

      let(:environment) { instance_double(described_class::Environment) }
      let(:sandbox) { instance_double(described_class::Sandbox) }

      context 'when everything succeeds' do
        let(:env) do
          {
            'GEM_HOME' => '/foo',
            'GEM_PATH' => '/foo',
            'PATH' => '/foo/bin:/usr/bar/bin'
          }
        end

        before do
          allow(Bundler).to receive(:with_clean_env).and_yield
          allow(Dir).to receive(:mktmpdir).and_yield(tmp_dir)
          allow(Dir).to receive(:chdir).and_yield

          allow(described_class::Sandbox).to receive(:new)
            .with(gemfile_options).and_return(sandbox)
          allow(sandbox).to receive(:gem_home).and_return(gem_home_path)
          allow(sandbox).to receive(:setup)

          allow(described_class::Environment).to receive(:new)
            .with(gem_home: gem_home_path).and_return(environment)
          allow(environment).to receive(:to_hash).and_return(env)
        end

        it 'calls the given block' do
          expect do |b|
            described_class.new(options, &b)
          end.to yield_with_args(env, instance_of(described_class))
        end
      end
    end
  end
end
