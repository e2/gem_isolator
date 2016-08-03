# frozen_string_literal: true
require 'gem_isolator/isolation/sandbox'

RSpec.describe GemIsolator::Isolation::Sandbox do
  subject { described_class.new(options) }
  let(:options) { { gems: [['foo', '~> 1.2']] } }

  describe '#system' do
    it 'runs a command' do
      expect(Kernel).to receive(:system).with('foo', 'bar').and_return(true)
      subject.system('foo', 'bar')
    end
  end

  describe '#setup' do
    let(:expected_args) { %w(bundle install --standalone --binstubs) }
    let(:gemfile) { instance_double(GemIsolator::Isolation::Gemfile) }
    let(:system_result) { true }

    before do
      allow(Kernel).to receive(:system).with(*expected_args)
        .and_return(system_result)

      allow(GemIsolator::Isolation::Gemfile).to receive(:new)
        .with(gems: [['foo', '~> 1.2']]).and_return(gemfile)
      allow(gemfile).to receive(:create)
    end

    it 'creates a gemfile' do
      expect(gemfile).to receive(:create)

      subject.setup
    end

    context 'when the command succeeds' do
      let(:system_result) { true }
      it 'installs gems with bundler in standalone mode' do
        expect(Kernel).to receive(:system).with(*expected_args)
        subject.setup
      end
    end

    context 'when the command fails' do
      let(:system_result) { false }
      it 'fails with an error' do
        expect do
          subject.setup
        end.to raise_error(
          described_class::Error::BundlerFailed,
          /sandbox setup with bundler failed/
        )
      end
    end

    context 'when bundler cannot be found' do
      let(:system_result) { nil }
      it 'fails' do
        expect do
          subject.setup
        end.to raise_error(Errno::ENOENT, /cannot run command 'bundle'/)
      end
    end
  end

  describe '#gem_home' do
    let(:pwd_path) { instance_double(Pathname) }
    let(:ruby_path) { instance_double(Pathname, :ruby_path) }
    let(:ruby_subdir) { '2.3.0' }
    let(:ruby_subdirs) { [ruby_subdir] }
    let(:gem_home_path) { instance_double(Pathname, :gem_home_path) }

    context 'with a sane setup' do
      before do
        allow(Pathname).to receive(:pwd).and_return(pwd_path)
        allow(pwd_path).to receive(:+).with("bundle/#{RUBY_ENGINE}")
          .and_return(ruby_path)

        allow(ruby_path).to receive(:children).and_return(ruby_subdirs)
        allow(ruby_path).to receive(:+).with(ruby_subdir)
          .and_return(gem_home_path)
      end

      it "points to directory containing a 'gems' subdir" do
        expect(subject.gem_home).to eq(gem_home_path)
      end
    end
  end
end
