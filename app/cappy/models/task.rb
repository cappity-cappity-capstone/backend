module Cappy
  module Models
    # This model represents a task for a device
    class Task < ActiveRecord::Base
      self.table_name = 'tasks'

      belongs_to :device
      has_many :schedules

      validates :state, presence: true
    end
  end
end
