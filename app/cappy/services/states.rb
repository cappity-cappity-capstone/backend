module Cappy
  module Services
    # This service handles converting JSON data to/from database models for the
    # states table. Also, database level errors are wrapped into application-
    # specific errors to make better use of HTTP errors codes in each
    # controller.
    module States
      include Base

      module_function

      def list(device)
        device.states.all.map(&:as_json)
      end

      def read(device)
        device.states.last.as_json
      end

      def create(device, data)
        wrap_active_record_errors { device.states.create!(data) }
      end
    end
  end
end
