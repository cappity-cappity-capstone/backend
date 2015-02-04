module Cappy
  module Controllers
    # This controller handle getting and creating states for a given device
    class States < Base
      get '/devices/:device_id/state/?' do |device_id|
        status 200
        device = Services::Devices.get_device(device_id)
        Services::States.read(device).to_json
      end

      post '/devices/:device_id/state/?' do |device_id|
        status 201
        device = Services::Devices.get_device(device_id)
        Services::States.create(device, parse_json(req_body)).to_json
      end
    end
  end
end
