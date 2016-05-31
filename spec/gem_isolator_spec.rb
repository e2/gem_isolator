# frozen_string_literal: true
require 'gem_isolator'

RSpec.describe GemIsolator do
  it 'has a version number' do
    expect(GemIsolator::VERSION).not_to be nil
  end

  describe '.isolate' do
    let(:isolation) { instance_double(described_class::Isolation) }

    before do
      allow(described_class::Isolation).to receive(:new).and_return(isolation)
    end

    context 'with valid options' do
      let(:options) { { gems: [['foo', '~> 1.2']] } }
      let(:passed_block) { instance_double(Proc) }
      let(:env) { { 'FOO' => 'BAR' } }

      before do
        allow(described_class::Isolation).to receive(:new)
          .with(options).and_yield(env, isolation)
      end

      it 'creates an instance of Isolation class' do
        allow(described_class::Isolation).to receive(:new)
          .with(options).and_yield(env, isolation)

        expect do |b|
          described_class.isolate(options, &b)
        end.to yield_with_args(env, isolation)
      end

      it 'calls the given block' do
        expect do |b|
          described_class.isolate(options, &b)
        end.to yield_with_args(env, isolation)
      end
    end
  end
end
