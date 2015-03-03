module Cappy
  module Services
    module OpenIgdPort
      @queue = :cappy
      CLOUD_CLIENT_HOST = ENV['CLOUD_CLIENT_HOST'] || 'http://cappitycappitycapstone.com'
      CLOUD_CLIENT_UUID = ENV['CLOUD_CLIENT_UUID'] || 'development'
      EXTERNAL_PORT = 10901

      module_function

      def perform
        if open_port
          begin
            cloud_client.create(CLOUD_CLIENT_UUID, EXTERNAL_PORT)
          rescue Errors::CloudClientError
            cloud_client.update(CLOUD_CLIENT_UUID, EXTERNAL_PORT)
          end
        end
      end

      def open_port
        begin
          client.call('AddPortMapping', message: {
            'NewRemoteHost' => '',
            'NewExternalPort' => EXTERNAL_PORT,
            'NewProtocol' => 'TCP',
            'NewInternalPort' => 4567,
            'NewInternalClient' => local_ip,
            'NewEnabled' => 1,
            'NewPortMappingDescription' => 'HAL CCS',
            'NewLeaseDuration' => 0
          })
          true
        rescue Savon::HTTPError => ex
          puts 'AddPortMapping failed!'
          puts "Class: #{ex.class}"
          puts "Message: #{ex.message}"
          false
        end
      end

      def local_ip
        if (ips = Socket.ip_address_list.select(&:ipv4_private?)).length > 0
          ips.first.ip_address
        else
          fail 'No local IP?'
        end
      end

      def find_control_url
        discover_devices.each do |device|
          if location = device.match(/^Location: (.*)$/)
            igd_url = URI.parse(location[1].strip)
            if control_url = get_control_url(igd_url.to_s)
              return URI.parse(
                File.join("http://#{igd_url.host}:#{igd_url.port}", control_url)
              ).to_s
            end
          end
        end
      end

      def discover_devices
        udp = UDPSocket.new
        search_str = <<EOF
M-SEARCH * HTTP/1.1
Host: 239.255.255.250:1900
Man: "ssdp:discover"
ST: upnp:rootdevice
MX: 3
EOF
        udp.send search_str, 0, "239.255.255.250", 1900
        sleep(0.5)

        responses = []
        begin
          loop do
            responses.push udp.recv_nonblock(4096)
          end
        rescue Errno::EAGAIN
        end

        responses
      end

      def get_control_url(url)
        response = Excon.get(url)
        body = response.body
        xml = Nokogiri::XML(body)
        xml.search('service').each do |service|
          if service.search('serviceType').text.match(/WANIPConnection/)
            return service.search('controlURL').text
          end
        end
      end

      def client
        Savon.client(
          endpoint: find_control_url,
          namespace: 'urn:schemas-upnp-org:service:WANIPConnection:1',
          log: true,
          pretty_print_xml: true,
          headers: { 'SOAPAction' => 'urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping' }
        )
      end

      def cloud_client
        CloudClient.new(CLOUD_CLIENT_HOST)
      end
    end
  end
end
