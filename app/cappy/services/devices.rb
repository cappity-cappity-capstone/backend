module Cappy
  module Services
    # This service handles converting JSON data to/from database models for the
    # devices table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module Devices
      module_function

      def list
        Models::Device.all.map(&:as_json)
      end

      def create(data)
        if Models::Device.exists?(device_id: data['device_id'])
          fail Errors::DuplicationError, "Device already exists with id: #{data['device_id']}"
        end

        wrap_active_record_errors { Models::Device.create!(data) }
      end

      def read(device_id)
        get_device(device_id).as_json
      end

      def update(device_id, data)
        wrap_active_record_errors do
          device = get_device(device_id)
          device.update_attributes!(data)
        end
      end

      def destroy(device_id)
        get_device(device_id).destroy
      end

      def get_device(device_id)
        Models::Device.find_by(device_id: device_id).tap do |device|
          fail Errors::NoSuchDevice, device_id unless device
        end
      end

      def wrap_active_record_errors
        yield
      rescue ActiveRecord::UnknownAttributeError, ActiveRecord::RecordInvalid => ex
        raise Errors::BadDeviceOptions, ex
      end
    end
  end
end
