# == Schema Information
#
# Table name: triggers
#
#  id       :integer          not null, primary key
#  alert_id :integer
#  state    :boolean
#

module Cappy
  module Models
    class Trigger < ActiveRecord::Base
      self.table_name = 'triggers'

      belongs_to :alert
    end
  end
end
