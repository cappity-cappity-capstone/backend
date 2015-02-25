module Cappy
  module Controllers
    # This controller returns Cappy's version. It can be used on deploys as a
    # live-check URL.
    class Devices < Base
      # Basic crud support

      get '/devices/?' do
        status 200
        Services::Devices.list.map do |device|
          Presenters::Device.new(device).present
        end.to_json
      end

      post '/devices/?' do
        status 201
        Presenters::Device.new(
          Services::Devices.create(parse_json(req_body))
        ).present.to_json
      end

      get '/devices/:device_id/?' do |device_id|
        status 200
        Presenters::Device.new(
          Services::Devices.read(device_id)
        ).present.to_json
      end

      put '/devices/:device_id/?' do |device_id|
        status 200
        Presenters::Device.new(
          Services::Devices.update(device_id, parse_json(req_body))
        ).present.to_json
      end

      delete '/devices/:device_id/?' do |device_id|
        status 204
        Services::Devices.destroy(device_id)
      end

      # Device specific

      put '/devices/:device_id/watchdog/?' do |device_id|
        status 200
        Presenters::Device.new(
          Services::Devices.update(device_id, last_check_in: Time.now.utc)
        ).present.to_json
      end
    end
  end
end
