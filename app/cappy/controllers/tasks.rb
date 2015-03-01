module Cappy
  module Controllers
    # This controller handles CRUD operations for schedules
    class Tasks < Base
      get '/tasks/?' do
        status 200
        Services::Tasks.list.to_json
      end

      get '/devices/:device_id/tasks/?' do |device_id|
        status 200
        Services::Tasks.for_device(device_id).to_json
      end

      post '/tasks/:device_id/?' do |device_id|
        status 201
        device = Services::Devices.get_device(device_id)
        Services::Tasks.create(device, parse_json(req_body)).to_json
      end

      get '/tasks/:tasks_id/?' do |tasks_id|
        status 200
        Services::Tasks.read(tasks_id).to_json
      end

      put '/tasks/:tasks_id/?' do |tasks_id|
        status 200
        Services::Tasks.update(tasks_id, parse_json(req_body)).to_json
      end

      delete '/tasks/:tasks_id/?' do |tasks_id|
        status 204
        Services::Tasks.destroy(tasks_id)
      end
    end
  end
end
