module Cappy
  module Services
    # Opens a port using the IGD service running on the router
    module OpenIgdPort
      @queue = :cappy
      CLOUD_CLIENT_HOST = ENV['CLOUD_CLIENT_HOST'] || 'http://cappitycappitycapstone.com'
      CLOUD_CLIENT_UUID = ENV['CLOUD_CLIENT_UUID'] || 'development'
      EXTERNAL_PORT = 10_901

      module_function

      def perform
        begin
          cloud_client.create(CLOUD_CLIENT_UUID, EXTERNAL_PORT)
        rescue Errors::CloudClientError
          cloud_client.update(CLOUD_CLIENT_UUID, EXTERNAL_PORT)
        end if open_port
      end

      def open_port
        client.call('AddPortMapping', message: open_port_payload)
        true
      rescue Savon::HTTPError => ex
        puts 'AddPortMapping failed!'
        puts "Class: #{ex.class}"
        puts "Message: #{ex.message}"
        false
      end

      def open_port_payload
        {
          'NewRemoteHost' => '',
          'NewExternalPort' => EXTERNAL_PORT,
          'NewProtocol' => 'TCP',
          'NewInternalPort' => 8080,
          'NewInternalClient' => local_ip,
          'NewEnabled' => 1,
          'NewPortMappingDescription' => 'HAL CCS',
          'NewLeaseDuration' => 0
        }
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
          next unless (location = device.match(/^location: (.*)$/i))

          igd_url = URI.parse(location[1].strip)
          next unless (control_url = get_control_url(igd_url.to_s))

          return URI.parse(
            File.join("http://#{igd_url.host}:#{igd_url.port}", control_url)
          ).to_s
        end
      end

      def discover_devices
        udp = UDPSocket.new
        udp.send(search_str, 0, '239.255.255.250', 1900)
        sleep(0.5)

        get_responses(udp)
      end

      def get_responses(udp)
        responses = []

        begin
          loop do
            responses.push udp.recv_nonblock(4096)
          end
        rescue Errno::EAGAIN
          nil
        end

        responses
      end

      def search_string
        <<EOF.gsub(/\n/, "\r\n")
M-SEARCH * HTTP/1.1
Host: 239.255.255.250:1900
MAN: "ssdp:discover"
ST: upnp:rootdevice
MX: 2
Connection: close
EOF
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
          headers: {
            'SOAPAction' => 'urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping'
          }
        )
      end

      def cloud_client
        CloudClient.new(CLOUD_CLIENT_HOST)
      end
    end
  end
end
