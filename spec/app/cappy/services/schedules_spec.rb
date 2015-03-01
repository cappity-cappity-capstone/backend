require 'spec_helper'

describe Cappy::Services::Schedules do
  let(:device) { create(:outlet) }
  let(:task_one) { create(:task, device: device) }
  let(:task_two) { create(:task, device: device) }

  describe '#list' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, task: task_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, task: task_two) }
    let(:schedules) { [schedule_one, schedule_two] }

    before { schedules.each(&:save!) }

    context 'without a task' do
      it 'returns a list of all of the schedules' do
        expect(subject.list).to eq(schedules)
      end
    end
  end

  describe '#for_device' do
    let(:device_two) { create(:lock) }
    let(:task_three) { create(:task, device: device_two) }
    let(:schedule_one) { create(:schedule_ends_immediately, task: task_one) }
    let(:schedule_two) { create(:schedule_forever_from_now, :hourly, task: task_two) }
    let(:schedule_three) { create(:schedule_forever_from_now, :hourly, task: task_three) }

    let(:expected_schedules) { [schedule_one, schedule_two] }

    context 'with a device' do
      it 'returns a list of all of the schedules' do
        expect(subject.for_device(device.device_id)).to eq(expected_schedules)
      end
    end
  end

  describe '#for_task' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, task: task_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, task: task_two) }
    let(:schedules) { [schedule_one, schedule_two] }

    before { schedules.each(&:save!) }

    context 'with a task' do
      it 'returns a list of all of the schedules' do
        expect(subject.for_task(task_one.id)).to eq([schedule_one])
      end
    end
  end

  describe '#create' do
    context 'when an invalid key is passed' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash[:test] = true } }

      it 'raises an error' do
        expect { subject.create(task_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when not enough keys are passed' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash.delete('interval') } }

      it 'raises an error' do
        expect { subject.create(task_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when all of the keys and values are valid' do
      let(:valid_hash) { build(:schedule_ends_immediately).as_json }
      let(:including_hash) { valid_hash.reject { |_, v| v.nil? }.to_h }

      it 'adds a new task' do
        subject.create(task_one, valid_hash)
        expect(subject.list.as_json).to match([a_hash_including(including_hash)])
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
      let(:schedule) { build(:schedule_ends_immediately, task: task_one) }

      before { schedule.save! }

      it 'returns the schedule' do
        expect(subject.read(schedule.id)).to eq(schedule)
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
      let(:schedule) { build(:schedule_ends_immediately, task: task_one) }

      before { schedule.save! }

      context 'but the data is invalid' do
        it 'raises an error' do
          expect { subject.update(schedule.id, schedule_type: 'stove') }
            .to raise_error(Cappy::Errors::BadOptions)
        end
      end

      context 'and the data is valid' do
        let(:time) { Time.new(2015, 02, 28, 14, 40, 00) }

        it 'updates the schedule' do
          subject.update(schedule.id, start_time: time)
          expect(subject.read(schedule.id)['start_time']).to eq(time.utc)
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
      let(:schedule) { build(:schedule_ends_immediately, task: task_one) }

      before { schedule.save! }

      it 'removes that schedule from the database' do
        subject.destroy(schedule.id)
        expect { subject.read(schedule.id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end
end
