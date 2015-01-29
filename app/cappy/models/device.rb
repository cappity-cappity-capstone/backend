module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      VALID_DEVICE_TYPES = %w(lock outlet gas_valve airbourne_alert)

      validates :device_id, presence: true
      validates :name, presence: true
      validates :device_type, presence: true, inclusion: { in: VALID_DEVICE_TYPES }
    end
  end
end
