module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      VALID_DEVICE_TYPES = %w(lock outlet gas_valve airbourne_alert)

      has_many :states
      has_many :tasks
      has_many :schedules, through: :tasks

      validates :device_id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :device_type, presence: true, inclusion: { in: VALID_DEVICE_TYPES }

      def as_json(*args)
        super.dup.tap do |hash|
          hash.delete('created_at')
          hash.delete('updated_at')
          hash['current_state'] = current_state.as_json
          hash['last_check_in'] = last_check_in.utc.iso8601 if last_check_in.present?
        end
      end

      def current_state
        states.last unless states.empty?
      end
    end
  end
end
