module Cappy
  module Models
    # This model represents a connected device
    class Device < ActiveRecord::Base
      self.table_name = 'devices'
      
      validates :device_id,     presence: true
      validates :name,          presence: true
      validates :device_type,   presence: true
      validates :last_check_in, presence: true
      validates :created_at,    presence: true
      validates :updated_at,    presence: true
    end
  end
end