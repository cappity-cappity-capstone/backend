module Cappy
  module Models
    # This model represents the state of a connected device
    class State < ActiveRecord::Base
      self.table_name = 'states'
      VALID_SOURCES = %w(scheduled parent_left manual_override)

      default_scope { order('created_at ASC') }

      belongs_to :device

      validates :device, presence: true
      validates :state, presence: true
      validates :source, presence: true, inclusion: { in: VALID_SOURCES }

      after_save { device.update(last_check_in: created_at) }

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
