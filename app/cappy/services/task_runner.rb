module Cappy
  module Services
    # This module handles running tasks when they need to be performed
    module TaskRunner
      @queue = :cappy

      module_function

      def perform
        previous = last_completed
        # Cutoff for tasks
        now = Models::TaskComplete.create

        tasks(previous.created_at, now.created_at).each do |task|
          task.device.states << Models::State.create(
            state: task.state,
            source: Cappy::Models::State::SCHEDULED
          )
        end
      end

      def tasks(last_task_time, this_task_time)
        unique_tasks = Set.new

        Models::Schedule.not_expired(this_task_time).each do |schedule|
          unique_tasks << schedule_within_time_range?(schedule, last_task_time, this_task_time)
        end

        unique_tasks.to_a.compact
      end

      def schedule_within_time_range?(schedule, last_time, this_time)
        if schedule.interval > 0
          last_multiple = multiple_for_time_and_schedule(last_time, schedule)
          this_multiple = multiple_for_time_and_schedule(this_time, schedule)
          schedule.task if last_multiple < this_multiple && this_multiple >= 0
        else
          if last_time < schedule.start_time && schedule.start_time <= this_time
            schedule.task
          end
        end
      end

      def multiple_for_time_and_schedule(time, schedule)
        ((time - schedule.start_time) / schedule.interval).floor
      end

      def last_completed
        Models::TaskComplete.last || Models::TaskComplete.starting_point
      end
    end
  end
end
