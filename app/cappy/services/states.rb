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
        device.states.all
      end

      def read(device)
        device.states.last
      end

      def create(device, data)
        wrap_active_record_errors { device.states.create!(data) }
      end

      def get_state(state_id)
        Models::State.find_by(id: state_id).tap do |state|
          fail Errors::NoSuchObject, state_id unless state
        end
      end
    end
  end
end
