# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  start_time :datetime         not null
#  end_time   :datetime
#  interval   :integer          not null
#  task_id    :integer
#

module Cappy
  module Models
    # This model represents a schedule for a task
    class Schedule < ActiveRecord::Base
      self.table_name = 'schedules'

      belongs_to :task

      validates :start_time, presence: true
      validates :interval, presence: true

      def as_json(*args)
        super.dup.tap do |hash|
          hash['start_time'] = start_time.utc.iso8601 if start_time.present?
          hash['end_time'] = end_time.utc.iso8601 if end_time.present?
        end
      end

      def self.not_expired(time)
        where('end_time > ? OR end_time IS NULL', time)
      end
    end
  end
end
