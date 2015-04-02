module Cappy
  module Services
    # This service handles converting JSON data to database models for the
    # tasks table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module Tasks
      include Base

      module_function

      def list
        Models::Task.all
      end

      def for_device(device_id = nil)
        device = Services::Devices.get_device(device_id)
        device.tasks.all
      end

      def create(device, data)
        wrap_active_record_errors { device.tasks.create!(data) }
      end

      def create_initial_tasks(device)
        create(device, state: 0.0)
        create(device, state: 1.0)
      end

      def read(task_id)
        get_task(task_id)
      end

      def update(task_id, data)
        wrap_active_record_errors do
          get_task(task_id).tap do |task|
            task.update_attributes!(data)
          end
        end
      end

      def destroy(task_id)
        get_task(task_id).destroy
      end

      def get_task(task_id)
        Models::Task.find_by(id: task_id).tap do |task|
          fail Errors::NoSuchObject, task_id unless task
        end
      end
    end
  end
end
