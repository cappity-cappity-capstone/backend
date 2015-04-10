module Cappy
  module Services
    # This class handles communication with the cloud servers.
    module CloudClient
      ROOT_PATH = '/auth/control_servers/'.freeze

      module_function

      # Create a control_server in the cloud.
      def create(port)
        request(
          method: 'POST',
          path: ROOT_PATH,
          body: { uuid: CLOUD_CLIENT_UUID, port: port }.to_json
        )
      end

      # Update the port for the given UUID.
      def update(port)
        request(
          method: 'PUT',
          path: File.join(ROOT_PATH, CLOUD_CLIENT_UUID),
          body: { port: port }.to_json
        )
      end

      def send_alert_email(alert)
        request(
          method: 'POST',
          path: File.join(ROOT_PATH, CLOUD_CLIENT_UUID, 'alert'),
          body: { alert: alert.as_json }.to_json
        )
      end

      def request(*args, &block)
        response = connection.request(*args, &block)
        handle_response_status!(response)
        JSON.parse(response.body)
      rescue JSON::JSONError => ex
        raise Errors::CloudClientError, ex
      end

      def handle_response_status!(response)
        msg = "Got a #{response.status} from the cloud server: #{response.body}"
        case response.status
        when 400..499
          fail Errors::CloudClientError, msg
        when 500..599
          fail Errors::CloudServerError, msg
        end
      end

      def connection
        @connection ||= Excon.new(CLOUD_CLIENT_HOST)
      end
    end
  end
end
