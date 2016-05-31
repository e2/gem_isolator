# frozen_string_literal: true
require 'gem_isolator/isolation/environment'

RSpec.describe GemIsolator::Isolation::Environment do
  subject { described_class.new(options) }

  describe '#to_hash' do
    let(:options) { { gem_home: Pathname('/tmp/foo') } }
    subject { described_class.new(options).to_hash }

    before do
      allow(ENV).to receive(:[]).with('PATH').and_return('/usr/bar/bin')
    end

    context 'with the gem home set to /tmp/foo' do
      it { is_expected.to include('GEM_HOME' => '/tmp/foo') }
      it { is_expected.to include('GEM_PATH' => '/tmp/foo') }
      it { is_expected.to include('PATH' => '/tmp/foo/bin:/usr/bar/bin') }
    end
  end
end
