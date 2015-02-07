require 'spec_helper'

describe Cappy::Services::Devices do
  describe '#list' do
    let(:device_one) { build(:lock) }
    let(:device_two) { build(:gas_valve) }
    let(:devices) { [device_one, device_two] }

    before { devices.each(&:save!) }

    it 'returns a list of all of the devices' do
      expect(subject.list).to eq(devices.map(&:as_json))
    end
  end

  describe '#create' do
    context 'when an invalid key is passed' do
      let(:valid_hash) { build(:outlet).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash[:test] = true } }

      it 'raises an error' do
        expect { subject.create(invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when not enough keys are passed' do
      let(:valid_hash) { build(:airbourne_alert).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash.delete('name') } }

      it 'raises an error' do
        expect { subject.create(invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when some of the keys reference invalid data' do
      let(:valid_hash) { build(:lock).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash['device_type'] = 'LOCK' } }

      it 'raises an error' do
        expect { subject.create(invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when there already exists a Device with that device id' do
      let(:valid_hash) { build(:lock).as_json }

      before { subject.create(valid_hash) }

      it 'raises an error' do
        expect { subject.create(valid_hash) }
          .to raise_error(Cappy::Errors::DuplicationError)
      end
    end

    context 'when all of the keys and values are valid' do
      let(:valid_hash) { build(:gas_valve).as_json }
      let(:including_hash) { valid_hash.reject { |_, v| v.nil? }.to_h }

      it 'adds a new device' do
        subject.create(valid_hash)
        expect(subject.list).to match([a_hash_including(including_hash)])
      end
    end
  end

  describe '#read' do
    context 'when there is no device with the given id' do
      it 'raises an error' do
        expect { subject.read('anything') }
          .to raise_error(Cappy::Errors::NoSuchDevice)
      end
    end

    context 'when there is a device with the given id' do
      let(:device) { build(:lock) }

      before { device.save! }

      it 'returns the device' do
        expect(subject.read(device.device_id)).to eq(device.as_json)
      end
    end
  end

  describe '#update' do
    context 'when the given device id cannot be found' do
      it 'raises an error' do
        expect { subject.update('anything', name: 'Kitchen') }
          .to raise_error(Cappy::Errors::NoSuchDevice)
      end
    end

    context 'when the given device id can be found' do
      let(:device) { build(:gas_valve) }

      before { device.save! }

      context 'but the data is invalid' do
        it 'raises an error' do
          expect { subject.update(device.device_id, device_type: 'stove') }
            .to raise_error(Cappy::Errors::BadOptions)
        end
      end

      context 'and the data is valid' do
        let(:name) { 'stove' }

        it 'updates the device' do
          subject.update(device.device_id, name: name)
          expect(subject.read(device.device_id)['name']).to eq(name)
        end
      end
    end
  end

  describe '.destroy' do
    context 'when the given device id does not exist' do
      it 'raises an error' do
        expect { subject.destroy('anything') }
          .to raise_error(Cappy::Errors::NoSuchDevice)
      end
    end

    context 'when the given device id exists' do
      let(:device) { build(:lock) }
      let(:device_id) { device.device_id }

      before { device.save! }

      it 'removes that device from the database' do
        subject.destroy(device_id)
        expect { subject.read(device_id) }
          .to raise_error(Cappy::Errors::NoSuchDevice)
      end
    end
  end
end
