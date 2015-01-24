module Cappy
  module Models
    # This model represents a Lock.
    class Lock < ActiveRecord::Base
      self.table_name = 'locks'

      validates :name, presence: true
      validates :device_id, presence: true
      validates :status, presence: true
    end
  end
end
