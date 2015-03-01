module Cappy
  module Services
    # I don't know what this does
    class CloudService
      include Base

      def initialize(host, port)
        @host = host
        @port = port
      end

      def create_control_server(mac, local_port)
        uuid = Digest::SHA1.hexdigest(mac)
        connection = Excon.new("#{@host}:#{@port}/control_servers")
        connection.post(body: JSON.generate(uuid: uuid,
                                            port: local_port))
      end

      def update_control_server(mac, local_port)
        uuid = Digest::SHA1.hexdigest(mac)
        connection = Excon.new("#{@host}:#{@port}/control_servers/#{uuid}")
        connection.post(body: JSON.generate(port: local_port))
      end
    end
  end
end
