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
            source: 'scheduled'
          )
        end
      end

      def tasks(last_task_time, this_task_time)
        unique_tasks = Set.new

        Models::Schedule.all.each do |schedule|
          if schedule.interval > 0
            last_interval_multiple = ((last_task_time - schedule.start_time) / schedule.interval).floor
            this_interval_multiple = ((this_task_time - schedule.start_time) / schedule.interval).floor
            if last_interval_multiple < this_interval_multiple
              unique_tasks << schedule.task
            end
          else
            if last_task_time < schedule.start_time && schedule.start_time < this_task_time
              unique_tasks << schedule.task
            end
          end
        end

        unique_tasks
      end

      def last_completed
        Models::TaskComplete.last || Models::TaskComplete.starting_point
      end
    end
  end
end
