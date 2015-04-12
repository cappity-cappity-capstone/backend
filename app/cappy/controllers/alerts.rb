module Cappy
  module Controllers
    # This controller returns Alert related information
    class Alerts < Base
      get '/alerts/?' do
        status 200
        Services::Alerts.list.map do |alert|
          Presenters::Alert.present(alert)
        end.to_json
      end

      post '/alerts/?' do
        status 201
        Presenters::Alert.present(
          Services::Alerts.create(parse_json(req_body))
        ).to_json
      end

      get '/alerts/:alert_id/?' do |alert_id|
        status 200
        Presenters::Alert.present(
          Services::Alerts.read(alert_id)
        ).to_json
      end

      put '/devices/:alert_id/?' do |alert_id|
        status 200
        Presenters::Alert.present(
          Services::Alerts.update(alert_id, parse_json(req_body))
        ).to_json
      end

      delete '/alerts/:alert_id/?' do |alert_id|
        status 204
        Services::Alerts.destroy(alert_id)
      end
    end
  end
end
