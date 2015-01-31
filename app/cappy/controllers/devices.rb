module Cappy
  module Controllers
    # This controller returns Cappy's version. It can be used on deploys as a
    # live-check URL.
    class Devices < Base
      # Basic crud support

      get '/devices/?' do
        status 200
        Services::Devices.list.to_json
      end

      post '/devices/?' do
        status 201
        Services::Devices.create(parse_json(req_body)).to_json
      end

      get '/devices/:device_id/?' do |device_id|
        status 200
        Services::Devices.read(device_id).to_json
      end

      put '/devices/:device_id/?' do |device_id|
        status 200
        Services::Devices.update(device_id, parse_json(req_body)).to_json
      end

      delete '/devices/:device_id/?' do |device_id|
        status 204
        Services::Devices.destroy(device_id)
      end

      # Device specific

      put '/devices/:device_id/watchdog/?' do |device_id|
        status 200
        Services::Devices.update(device_id, last_check_in: Time.now.utc)
      end

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
