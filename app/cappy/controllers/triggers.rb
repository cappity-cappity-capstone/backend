module Cappy
  module Controllers
    # This controller handle getting and creating triggers for a given alert
    class Triggers < Base
      helpers { include Services::Triggers }

      get '/alerts/:alert_id/triggers/?' do |alert_id|
        status 200
        alert = Services::Alerts.get_alert(alert_id)
        list(alert, params[:page], params[:count]).to_json
      end

      get '/alerts/:alert_id/trigger/?' do |alert_id|
        status 200
        alert = Services::Alerts.get_alert(alert_id)
        read(alert).to_json
      end

      post '/alerts/:alert_id/trigger/?' do |alert_id|
        status 201
        alert = Services::Alerts.get_alert(alert_id)
        create(alert, parse_json(req_body)).to_json
      end
    end
  end
end
