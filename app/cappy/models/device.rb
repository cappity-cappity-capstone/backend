module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      valid_device_types = %w(lock outlet gas_valve airbourne_alert)

      validates :device_id,     presence: true
      validates :name,          presence: true
      validates :device_type,   presence: true, inclusion: { in: valid_device_types }
      validates :last_check_in, presence: true
      validates :created_at,    presence: true
      validates :updated_at,    presence: true

      validate :last_check_in_is_after_created_at

      def last_check_in_is_after_created_at
        return if last_check_in.nil? || last_check_in >= created_at
        errors.add(:last_check_in, 'must be after created_at')
      end
    end
  end
end
