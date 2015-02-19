module Cappy
  module Services
    # Resque job service that sends off 5 UDP messages
    module Broadcast
      @queue = :cappy
      BROADCAST_ADDRESS = '255.255.255.255'
      BROADCAST_PORT = 10_000

      module_function

      def perform
        puts 'Starting CCS broadcast'
        send_message
      end

      def send_message
        socket.send('HAL CCS', 0, BROADCAST_ADDRESS, BROADCAST_PORT)
      end

      def socket
        @socket ||= UDPSocket.new.tap do |s|
          s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
        end
      end
    end
  end
end
