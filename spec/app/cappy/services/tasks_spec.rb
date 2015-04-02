require 'spec_helper'

describe Cappy::Services::Tasks do
  let(:device_one) { create(:lock) }
  let(:device_two) { create(:outlet) }

  describe '#list' do
    let(:task_one) { build(:task, device: device_one) }
    let(:task_two) { build(:task, device: device_two) }
    let(:tasks) { [task_one, task_two] }

    before { tasks.each(&:save!) }

    context 'without a device' do
      it 'returns a list of all of the tasks' do
        expect(subject.list).to eq(tasks)
      end
    end
  end

  describe '#for_device' do
    let(:task_one) { build(:task, device: device_one) }
    let(:task_two) { build(:task, device: device_two) }
    let(:tasks) { [task_one, task_two] }

    before { tasks.each(&:save!) }

    context 'with a device' do
      it 'returns a list of all of the tasks' do
        expect(subject.for_device(device_one.device_id)).to eq([task_one])
      end
    end
  end

  describe '#create' do
    context 'when an invalid key is passed' do
      let(:valid_hash) { build(:task).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash[:test] = true } }

      it 'raises an error' do
        expect { subject.create(device_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when not enough keys are passed' do
      let(:valid_hash) { build(:task).as_json }
      let(:invalid_hash) { valid_hash.tap { |hash| hash.delete('state') } }

      it 'raises an error' do
        expect { subject.create(device_one, invalid_hash) }
          .to raise_error(Cappy::Errors::BadOptions)
      end
    end

    context 'when all of the keys and values are valid' do
      let(:valid_hash) { build(:task).as_json }
      let(:including_hash) { valid_hash.reject { |_, v| v.nil? }.to_h }

      it 'adds a new device' do
        subject.create(device_one, valid_hash)
        expect(subject.list.as_json).to match([a_hash_including(including_hash)])
      end
    end
  end

  describe '#create_initial_tasks' do
    let(:method) { subject.create_initial_tasks(device_one) }
    it 'adds the two tasks for a device' do
      expect { method }.to change { Cappy::Models::Task.count }.by(2)
    end
  end

  describe '#read' do
    context 'when there is no task with the given id' do
      it 'raises an error' do
        expect { subject.read('anything') }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when there is a task with the given id' do
      let(:task) { build(:task, device: device_one) }

      before { task.save! }

      it 'returns the task' do
        expect(subject.read(task.id)).to eq(task)
      end
    end
  end

  describe '#update' do
    context 'when the given task id cannot be found' do
      it 'raises an error' do
        expect { subject.update('anything', state: 1) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when the given task id can be found' do
      let(:task) { build(:task, device: device_one) }

      before { task.save! }

      context 'but the data is invalid' do
        it 'raises an error' do
          expect { subject.update(task.id, task_type: 'stove') }
            .to raise_error(Cappy::Errors::BadOptions)
        end
      end

      context 'and the data is valid' do
        let(:time) { Time.now }

        it 'updates the task' do
          subject.update(task.id, state: 1.0)
          expect(subject.read(task.id)['state']).to eq(1.0)
        end
      end
    end
  end

  describe '.destroy' do
    context 'when the given task id does not exist' do
      it 'raises an error' do
        expect { subject.destroy('anything') }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end

    context 'when the given task id exists' do
      let(:task) { build(:task, device: device_one) }

      before { task.save! }

      it 'removes that task from the database' do
        subject.destroy(task.id)
        expect { subject.read(task.id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end
end
