require 'spec_helper'

describe Cappy::Services::Schedules do
  let(:device_one) { create(:lock) }
  let(:device_two) { create(:outlet) }

  describe '#list' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, device: device_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, device: device_two) }
    let(:schedules) { [schedule_one, schedule_two] }

    before { schedules.each(&:save!) }

    context 'without a device' do
      it 'returns a list of all of the schedules' do
        expect(subject.list).to eq(schedules.map(&:as_json))
      end
    end
  end

  describe '#for_device' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, device: device_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, device: device_two) }
    let(:schedules) { [schedule_one, schedule_two] }

    before { schedules.each(&:save!) }

    context 'with a device' do
      it 'returns a list of all of the schedules' do
        expect(subject.for_device(device_one.device_id)).to eq([schedule_one.as_json])
      end
    end
  end

  describe '#create' do
    context 'when an invalid key is passed' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash[:test] = true } }

      it 'raises an error' do
        expect { subject.create(device_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when not enough keys are passed' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash.delete('interval') } }

      it 'raises an error' do
        expect { subject.create(device_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when all of the keys and values are valid' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:including_hash) { valid_hash.reject { |_, v| v.nil? }.to_h }

      it 'adds a new device' do
        subject.create(device_one, valid_hash)
        expect(subject.list).to match([a_hash_including(including_hash)])
      end
    end
  end

  describe '#read' do
    context 'when there is no schedule with the given id' do
      it 'raises an error' do
        expect { subject.read('anything') }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when there is a schedule with the given id' do
      let(:schedule) { build(:schedule_ends_immediately, device: device_one) }

      before { schedule.save! }

      it 'returns the schedule' do
        expect(subject.read(schedule.id)).to eq(schedule.as_json)
      end
    end
  end

  describe '#update' do
    context 'when the given schedule id cannot be found' do
      it 'raises an error' do
        expect { subject.update('anything', start_time: Time.now) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when the given schedule id can be found' do
      let(:schedule) { build(:schedule_ends_immediately, device: device_one) }

      before { schedule.save! }

      context 'but the data is invalid' do
        it 'raises an error' do
          expect { subject.update(schedule.id, schedule_type: 'stove') }
            .to raise_error(Cappy::Errors::BadOptions)
        end
      end

      context 'and the data is valid' do
        let(:time) { Time.now }

        it 'updates the schedule' do
          subject.update(schedule.id, start_time: time)
          expect(subject.read(schedule.id)['start_time']).to eq(time.utc.iso8601)
        end
      end
    end
  end

  describe '.destroy' do
    context 'when the given schedule id does not exist' do
      it 'raises an error' do
        expect { subject.destroy('anything') }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when the given schedule id exists' do
      let(:schedule) { build(:schedule_ends_immediately, device: device_one) }

      before { schedule.save! }

      it 'removes that schedule from the database' do
        subject.destroy(schedule.id)
        expect { subject.read(schedule.id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end
end
