require 'spec_helper'

describe Cappy::Services::TaskRunner do
  describe '.perform' do
    let(:device) { create(:lock) }
    let(:task) { create(:task, device: device) }
    let!(:schedule) do
      create(
        :schedule_ends_immediately,
        start_time: Time.new(2015, 2, 28, 17, 40, 00),
        task: task
      )
    end

    it 'makes a new task complete and runs the tasks' do
      expect do
        described_class.perform
      end.to change { Cappy::Models::TaskComplete.count }.by(1)
        .and change { device.states.count }.by(1)
    end
  end

  describe '.tasks' do
    shared_examples 'tasks within a timerange' do
      it do
        expect(
          described_class.tasks(last_time, this_time)
        ).to eq(expected)
      end
    end

    let(:start_time) { Time.new(2015, 2, 28, 10, 00, 00) }
    let(:end_time) { Time.new(2015, 2, 28, 11, 00, 00) }
    let(:device) { create(:outlet) }
    let(:task) { create(:task, device: device) }
    let!(:schedule) do
      create(
        :schedule, :minutely,
        start_time: start_time,
        end_time: end_time,
        task: task
      )
    end

    context 'when there are two schedules for the same task and both apply' do
      let!(:schedule_two) do
        create(
          :schedule,
          interval: 0,
          start_time: start_time,
          task: task
        )
      end
      let(:last_time) { start_time - 1.minutes }
      let(:this_time) { start_time + 1.minute }
      let(:expected) { [task] }

      it_behaves_like 'tasks within a timerange'
    end

    context 'when the start time has not been crossed' do
      let(:last_time) { start_time - 2.minutes }
      let(:this_time) { start_time - 1.minutes }
      let(:expected) { [] }

      it_behaves_like 'tasks within a timerange'
    end

    context 'when the start time is now' do
      let(:last_time) { start_time - 1.minutes }
      let(:this_time) { start_time }
      let(:expected) { [task] }

      it_behaves_like 'tasks within a timerange'
    end

    context 'when the start time is before now and the end time is after' do
      let(:last_time) { start_time }
      let(:this_time) { start_time + 1.minute }
      let(:expected) { [task] }

      it_behaves_like 'tasks within a timerange'
    end

    context 'when the start time is before now and the end time is now' do
      let(:last_time) { end_time - 1.minute }
      let(:this_time) { end_time }
      let(:expected) { [] }

      it_behaves_like 'tasks within a timerange'
    end

    context 'when the start time is before now and the end time is before now' do
      let(:last_time) { end_time }
      let(:this_time) { end_time + 1.minute }
      let(:expected) { [] }

      it_behaves_like 'tasks within a timerange'
    end
  end

  describe '.schedule_within_time_range?' do
    let(:task) { build(:task) }
    let(:last_time) { Time.new(2015, 2, 28,  9, 59, 00) }
    let(:this_time) { Time.new(2015, 2, 28, 10, 00, 00) }
    subject do
      described_class.schedule_within_time_range?(
        schedule, last_time, this_time
      )
    end

    context 'with a schedule that runs more than once' do
      context 'and starts at the same second' do
        let(:schedule) { build(:schedule, :minutely, start_time: this_time, task: task) }

        it 'returns the task' do
          expect(subject).to eq(task)
        end
      end

      context 'and starts a second later' do
        let(:schedule) { build(:schedule, :minutely, start_time: this_time + 1, task: task) }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    context 'with a schedule that runs only once' do
      context 'and starts at the last time' do
        let(:schedule) { build(:schedule_ends_immediately, start_time: last_time, task: task) }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end

      context 'and starts at the same second' do
        let(:schedule) { build(:schedule_ends_immediately, start_time: this_time, task: task) }

        it 'returns the task' do
          expect(subject).to eq(task)
        end
      end

      context 'and starts a second later' do
        let(:schedule) { build(:schedule_ends_immediately, start_time: this_time + 1, task: task) }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end
  end

  describe '.multiple_for_time_and_schedule' do
    let(:time) { Time.new(2015, 02, 28, 10, 00, 00) }
    subject { described_class.multiple_for_time_and_schedule(time, schedule) }

    context 'an hour later' do
      let(:schedule) { build(:schedule, :hourly, start_time: time - 1.hour) }

      it do
        expect(subject).to eq(1)
      end
    end

    context 'an hour before' do
      let(:schedule) { build(:schedule, :hourly, start_time: time + 1.hour) }

      it do
        expect(subject).to eq(-1)
      end
    end

    context 'a second before' do
      let(:schedule) { build(:schedule, :hourly, start_time: time + 1) }

      it do
        expect(subject).to eq(-1)
      end
    end

    context 'the same second' do
      let(:schedule) { build(:schedule, :hourly, start_time: time) }

      it do
        expect(subject).to eq(0)
      end
    end

    context '59 minutes and 59 seconds after' do
      let(:schedule) { build(:schedule, :hourly, start_time: time - (59.minutes + 59)) }

      it do
        expect(subject).to eq(0)
      end
    end
  end

  describe '.last_completed' do
    context 'without a TaskComplete yet' do
      before do
        Cappy::Models::TaskComplete.all.each(&:destroy)
      end

      it 'uses starting_point' do
        expect(Cappy::Models::TaskComplete).to receive(:starting_point)
        subject.last_completed
      end
    end

    context 'with a TaskComplete' do
      let!(:task_complete) { Cappy::Models::TaskComplete.create }

      it 'uses the last TaskComplete' do
        expect(subject.last_completed).to eq(task_complete)
      end
    end
  end
end
