module Cappy
  module Services
    # Fires off the state to the right device
    module DispatchState
      @queue = :cappy

      DEVICE_PORT = 4_567
      ATTEMPTS = 3

      module_function

      def perform(state_id)
        attempts ||= ATTEMPTS
        puts "Attempt ##{ATTEMPTS - attempts + 1}"
        state = Services::States.get_state(state_id)
        device_id = state.device.device_id
        value = state.state.to_s('F')
        ip_address = state.device.ip_address

        puts "IP: #{ip_address} value: #{value}"

        Timeout.timeout(0.5) do
          send_state_to_ip(device_id, value, ip_address)
        end
      rescue TimeoutError
        retry unless (attempts -= 1).zero?
        nil
      end

      def send_state_to_ip(device_id, state, ip_address)
        socket = TCPSocket.open(ip_address, DEVICE_PORT)
        puts "Socket: #{socket}"
        socket.write(device_id)
        socket.write("\n")
        socket.write(state)
        socket.write("\n")
        socket.close
      end
    end
  end
end
