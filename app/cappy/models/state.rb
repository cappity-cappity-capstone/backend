module Cappy
  module Models
    # This model represents the state of a connected device
    class State < ActiveRecord::Base
      self.table_name = 'states'
      VALID_SOURCES = %w(scheduled parent_left manual_override)

      validates :device_id,  presence: true
      validates :state,      presence: true
      validates :source,     presence: true, inclusion: { in: VALID_SOURCES }
      validates :created_at, presence: true
    end
  end
end
