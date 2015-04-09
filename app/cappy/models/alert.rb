# == Schema Information
#
# Table name: alerts
#
#  id   :integer          not null, primary key
#  name :string
#

module Cappy
  module Models
    class Alert < ActiveRecord::Base
      self.table_name = 'alerts'

      has_many :devices
      has_many :triggers
    end
  end
end
