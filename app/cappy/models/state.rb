module Cappy
  module Models
    # This model represents the state of a connected device
    class State < ActiveRecord::Base
      self.table_name = 'states'
      SCHEDULED = 'scheduled'
      PARENT_LEFT = 'parent_left'
      MANUAL_OVERRIDE = 'manual_override'

      VALID_SOURCES = [SCHEDULED, PARENT_LEFT, MANUAL_OVERRIDE]

      default_scope { order('created_at ASC') }

      belongs_to :device

      validates :device, presence: true
      validates :state, presence: true
      validates :source, presence: true, inclusion: { in: VALID_SOURCES }

      def as_json(*args)
        super.dup.tap do |hash|
          hash.delete('id')
          hash.delete('device_id')
          hash.delete('created_at')
          hash.delete('updated_at')
          hash['state'] = state.to_s('F')
        end
      end
    end
  end
end
