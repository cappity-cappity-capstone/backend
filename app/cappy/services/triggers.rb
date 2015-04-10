module Cappy
  module Services
    # Service module for creating new triggers
    module Triggers
      include Base

      module_function

      def list(alert, page = nil, count = nil)
        page ||= 0
        count ||= 15
        alert.triggers.order('created_at DESC').limit(count).offset(page * count)
      end

      def read(alert)
        alert.triggers.last
      end

      def create(alert, data)
        wrap_active_record_errors do
          last_trigger = read(alert)

          if last_trigger.nil? || last_trigger.state != data['state']
            alert.triggers.create!(data).tap do |trigger|
              trigger_device_reaction(trigger) if trigger.state
            end
          end
        end
      end

      def trigger_device_reaction(trigger)
        alert = trigger.alert

        Services::CloudClient.send_alert_email(alert)
        Services::Alerts.turn_off_devices(alert)
      end
    end
  end
end
