module Cappy
  module Models
    # Maintains the record of the last time tasks were run
    class TaskComplete < ActiveRecord::Base
      self.table_name = 'task_complete'

      def self.starting_point
        new(created_at: Time.mktime(0))
      end
    end
  end
end
