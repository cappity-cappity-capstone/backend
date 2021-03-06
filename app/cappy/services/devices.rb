module Cappy
  module Services
    # This service handles converting JSON data to/from database models for the
    # devices table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module Devices
      include Base

      module_function

      def list
        Models::Device.all
      end

      def create(data)
        if Models::Device.exists?(device_id: data['device_id'])
          fail Errors::DuplicationError, "Device already exists with id: #{data['device_id']}"
        end

        wrap_active_record_errors do
          Models::Device.create!(data).tap do |device|
            Services::Tasks.create_initial_tasks(device)
          end
        end
      end

      def read(device_id)
        get_device(device_id)
      end

      def update(device_id, data)
        wrap_active_record_errors do
          get_device(device_id).tap do |device|
            device.update_attributes!(data)
          end
        end
      end

      def destroy(device_id)
        get_device(device_id).destroy
      end

      def get_device(device_id)
        Models::Device.find_by(device_id: device_id).tap do |device|
          fail Errors::NoSuchObject, device_id unless device
        end
      end
    end
  end
end
