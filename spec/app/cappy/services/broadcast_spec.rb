require 'spec_helper'

describe Cappy::Services::Broadcast do
  describe '.perform' do
    let(:worker) { Resque::Worker.new('*') }
    before { allow(subject).to receive(:sleep) }
    it 'will build a socket and send 5 messages' do
      expect(subject.socket).to receive(:send)
      Resque.enqueue(subject)
      job = nil
      loop do
        job = worker.reserve
        break if job
      end
      worker.perform(job)
    end
  end
end
