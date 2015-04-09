# == Schema Information
#
# Table name: devices
#
#  id            :integer          not null, primary key
#  device_id     :string           not null
#  name          :string           not null
#  device_type   :string           not null
#  last_check_in :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  unit          :string
#  alert_id      :integer
#

module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      VALID_DEVICE_TYPES = %w(lock outlet gas_valve airbourne_alert)

      belongs_to :alert

      has_many :states
      has_many :tasks
      has_many :schedules, through: :tasks

      validates :device_id, presence: true
      validates :name, presence: true
      validates :device_type, presence: true, inclusion: { in: VALID_DEVICE_TYPES }

      def as_json(*args)
        super.dup.tap do |hash|
          hash.delete('created_at')
          hash.delete('updated_at')
          hash['last_check_in'] = last_check_in.utc.iso8601 if last_check_in.present?
        end
      end
    end
  end
end
