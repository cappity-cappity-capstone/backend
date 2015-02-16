module Cappy
  module Services
    # I don't know what this does
    module CloudService
      CLOUD_ADDR = 'http://localhost:4567/auth'

      include Base

      module_function

      def create_control_server(local_port)
        uuid = Digest::SHA1.hexdigest Mac.addr
        connection = Excon.new('#{CLOUD_ADDR}/control_servers')
        connection.post(body: JSON.generate(:uuid => uuid, :port => local_port))
      end

      def update_control_server(local_port)
        uuid = Digest::SHA1.hexdigest Mac.addr
        connection = Excon.new('#{CLOUD_ADDR}/control_servers/#{uuid}')
        connection.post(body: JSON.generate(:port => local_port))
      end
    end
  end
end
