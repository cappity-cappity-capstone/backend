module Cappy
  module Controllers
    # This controller returns Cappy's version. It can be used on deploys as a
    # live-check URL.
    class Devices < Base
      get '/devices/' do
        status 200
        Services::Devices.list.to_json
      end

      post '/devices/' do
        status 201
        Services::Devices.create(parse_json(req_body)).to_json
      end

      get '/devices/:device_id/' do |device_id|
        status 200
        Services::Devices.read(device_id).to_json
      end

      put '/devices/:device_id/' do |device_id|
        status 200
        Services::Devices.update(device_id, parse_json(req_body)).to_json
      end

      delete '/devices/:device_id/' do |device_id|
        status 204
        Services::Devices.destroy(device_id)
      end
    end
  end
end
