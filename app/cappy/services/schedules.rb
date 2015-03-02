module Cappy
  module Services
    # This service handles converting JSON data to database models for the
    # schedules table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module Schedules
      include Base

      module_function

      def list
        Models::Schedule.all
      end

      def for_device(device_id = nil)
        device = Services::Devices.get_device(device_id)
        device.schedules.all
      end

      def for_task(task_id = nil)
        task = Services::Tasks.get_task(task_id)
        task.schedules.all
      end

      def create(task, data)
        wrap_active_record_errors { task.schedules.create!(data) }
      end

      def read(schedule_id)
        get_schedule(schedule_id)
      end

      def update(schedule_id, data)
        wrap_active_record_errors do
          get_schedule(schedule_id).tap do |schedule|
            schedule.update_attributes!(data)
          end
        end
      end

      def destroy(schedule_id)
        get_schedule(schedule_id).destroy
      end

      def get_schedule(schedule_id)
        Models::Schedule.find_by(id: schedule_id).tap do |schedule|
          fail Errors::NoSuchObject, schedule_id unless schedule
        end
      end
    end
  end
end
