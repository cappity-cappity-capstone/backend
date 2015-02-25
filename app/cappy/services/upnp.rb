require 'socket'
require 'UPnP/service'
require 'UPnP/device'

module UPnP
  class Service
    # UPnP service
    class CappyUPnPService < UPnP::Service
      add_action 'forward',
                 [IN, 'ObjectID',       'A_ARG_TYPE_ObjectID'],

                 [OUT, 'Result',         'A_ARG_TYPE_Result']

      add_variable 'A_ARG_TYPE_ObjectID', 'string'
      add_variable 'A_ARG_TYPE_Result',   'string'

      def forward
        result = 'OK'
        [nil, result]
      end
    end
  end

  class Device
    # UPnP Device
    class CappyUPnPDevice < UPnP::Device
      VERSION = '1.0'

      add_service_id UPnP::Service::CappyUPnPService, 'CappyUPnPService'
    end
  end
end

module Cappy
  module Services
    # The Cappy UPnP Service creation.
    module UPnPService
      module_function

      # Creates the cappy UPnP Service
      def start
        name = Socket.gethostname.split('.', 2).first

        device = UPnP::Device.create 'CappyUPnPDevice', name do |ms|
          ms.manufacturer = 'Cappy'
          ms.model_name = 'Cappy UPnP Device'

          ms.add_service 'CappyUPnPService'
        end

        Thread.new { device.run }

        port = device.setup_server.config[:Port]
        Cappy::Services::CloudService.create_control_server(port)
      end
    end
  end
end

# curl localhost:57113/description
# curl -X POST localhost:57113/CappyUPnPDevice/CappyUPnPService/control -H "Content-Type: text/xml; charset="utf-8"; Content-Length: 1;" -H "SoapAction: urn:schemas-upnp-org:service:CappyUPnPService:1#forward" -d ''
