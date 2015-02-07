module Cappy
  module Controllers
    # This controller handles CRUD operations for schedules
    class Schedules < Base
      get '/schedules/?' do
        status 200
        Services::Schedules.list.to_json
      end

      get '/devices/:device_id/schedules/?' do |device_id|
        status 200
        Services::Schedules.list(device_id).to_json
      end

      post '/schedules/:device_id/?' do |device_id|
        status 201
        device = Services::Devices.get_device(device_id)
        Services::Schedules.create(device, parse_json(req_body)).to_json
      end

      get '/schedules/:schedule_id/?' do |schedule_id|
        status 200
        Services::Schedules.read(schedule_id).to_json
      end

      put '/schedules/:schedule_id/?' do |schedule_id|
        status 200
        Services::Schedules.update(schedule_id, parse_json(req_body)).to_json
      end

      delete '/schedules/:schedule_id/?' do |schedule_id|
        status 204
        Services::Schedules.destroy(schedule_id)
      end
    end
  end
end
