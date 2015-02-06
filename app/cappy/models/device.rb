module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      VALID_DEVICE_TYPES = %w(lock outlet gas_valve airbourne_alert)

      has_many :states

      validates :device_id, presence: true
      validates :name, presence: true
      validates :device_type, presence: true, inclusion: { in: VALID_DEVICE_TYPES }

      def as_json(*args)
        super.dup.tap do |hash|
          hash.delete('created_at')
          hash.delete('updated_at')
          hash['last_check_in'] = last_check_in.utc.iso8601 if last_check_in.present?
          hash['state'] = states.any? ? states.last.state : nil
        end
      end
    end
  end
end
