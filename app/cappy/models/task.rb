module Cappy
  module Models
    # This model represents a task for a device
    class Task < ActiveRecord::Base
      self.table_name = 'tasks'

      belongs_to :device
      has_many :schedules

      validates :state, presence: true

      def as_json(*args)
        super.dup.tap do |hash|
          hash['state'] = state.to_s('F')
        end
      end
    end
  end
end
