# == Schema Information
#
# Table name: task_complete
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

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
