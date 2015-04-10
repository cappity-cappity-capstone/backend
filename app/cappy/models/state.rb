# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  device_id  :integer          not null
#  state      :decimal(, )      not null
#  source     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Cappy
  module Models
    # This model represents the state of a connected device
    class State < ActiveRecord::Base
      self.table_name = 'states'
      SCHEDULED = 'scheduled'
      PARENT_LEFT = 'parent_left'
      MANUAL_OVERRIDE = 'manual_override'
      ALERT = 'alert'

      VALID_SOURCES = [SCHEDULED, PARENT_LEFT, MANUAL_OVERRIDE, ALERT]

      belongs_to :device

      validates :device, presence: true
      validates :state, presence: true
      validates :source, presence: true, inclusion: { in: VALID_SOURCES }

      def as_json(*args)
        super.dup.tap do |hash|
          hash.delete('device_id')
          hash['created_at'] = created_at.iso8601
          hash.delete('updated_at')
          hash['state'] = state.to_s('F')
        end
      end
    end
  end
end
