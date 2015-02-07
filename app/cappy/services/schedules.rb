module Cappy
  module Services
    # This service handles converting JSON data to/from database models for the
    # schedules table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module Schedules
      include Base

      module_function

      def list(device_id = nil)
        if device_id.nil?
          Models::Schedule.all.map(&:as_json)
        else
          device = Services::Devices.get_device(device_id)
          device.schedules.all.map(&:as_json)
        end
      end

      def create(device, data)
        wrap_active_record_errors { device.schedules.create!(data) }
      end

      def read(schedule_id)
        get_schedule(schedule_id).as_json
      end

      def update(schedule_id, data)
        wrap_active_record_errors do
          schedule = get_schedule(schedule_id)
          schedule.update_attributes!(data)
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
