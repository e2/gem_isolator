# frozen_string_literal: true
require 'gem_isolator/isolation/gemfile'

RSpec.describe GemIsolator::Isolation::Gemfile do
  subject { described_class.new(options) }

  describe '#create' do
    let(:options) { { gems: [['foo', '~> 1.2']] } }

    before do
      allow(IO).to receive(:write)
    end

    context 'with valid options' do
      it 'writes the Gemfile' do
        expect(IO).to receive(:write).with('Gemfile', /gem "foo", "~> 1\.2"/)
        subject.create
      end
    end
  end
end
