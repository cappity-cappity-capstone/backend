module Cappy
  module Presenters
    # This presenter shows a device with it's last state
    class Device
      attr_reader :device

      def initialize(device)
        @device = device
      end

      def present
        {
          device: device.as_json
        }.merge(state_presentation || {})
      end

      def state_presentation
        { state: device.states.last.as_json } if device.states.any?
      end
    end
  end
end
