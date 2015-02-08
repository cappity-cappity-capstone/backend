require 'spec_helper'

describe Cappy::Services::States do
  let(:device) { create(:lock) }

  describe '#list' do
    let(:state_one) { build(:on_state, :scheduled, device: device) }
    let(:state_two) { build(:off_state, :manual_override, device: device) }
    let(:states) { [state_one, state_two] }

    before { states.each(&:save!) }

    it 'returns a list of all of the statuses' do
      expect(subject.list(device)).to eq(states.map(&:as_json))
    end
  end

  describe '#read' do
    let(:state_one) { build(:on_state, :scheduled, device: device) }
    let(:state_two) { build(:off_state, :manual_override, device: device) }

    before { [state_one, state_two].each(&:save!) }

    it 'returns the last status' do
      expect(subject.read(device)).to eq(state_two.as_json)
    end
  end

  describe '#create' do
    let(:data) { { state: 1.0, source: 'manual_override' } }

    it 'creates a new state' do
      expect { subject.create(device, data) }.to change { Cappy::Models::State.count }.by(1)
    end

    context 'when some data is missing' do
      let(:data) { { state: 1.0 } }

      it 'raises a bad state options error' do
        expect { subject.create(device, data) }.to raise_error(Cappy::Errors::BadOptions)
      end
    end
  end
end
