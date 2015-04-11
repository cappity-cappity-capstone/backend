module Cappy
  module Services
    # Service module for creating new alerts
    module Alerts
      include Base

      module_function

      def list
        Models::Alert.all
      end

      def create(data)
        if Models::Alert.exists?(alert_id: data['alert_id'])
          fail Errors::DuplicationError, "Alert already exists with id: #{data['alert_id']}"
        end

        wrap_active_record_errors do
          Models::Alert.create(data).tap do |alert|
            provision_for_default_devices(alert)
          end
        end
      end

      def read(alert_id)
        get_alert(alert_id)
      end

      def update(alert_id, data)
        wrap_active_record_errors do
          get_alert(alert_id).tap do |alert|
            alert.update_attributes!(data)
          end
        end
      end

      def destroy(alert_id)
        get_alert(alert_id).destroy
      end

      def get_alert(alert_id)
        Models::Alert.find_by(alert_id: alert_id).tap do |alert|
          fail Errors::NoSuchObject, alert_id unless alert
        end
      end

      # Ugly, but who cares
      def provision_for_default_devices(alert)
        case alert.type
        when 'airbourne_alert'
          Models::Device.where(device_type: 'gas_valve').each do |device|
            device.alert = alert
            device.save!
          end
        end
      end

      def turn_off_devices(alert)
        alert.devices.each do |device|
          Services::States.create(device, 'state' => 0.0, 'source' => Models::State::ALERT)
        end
      end
    end
  end
end
