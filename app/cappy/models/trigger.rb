# == Schema Information
#
# Table name: triggers
#
#  id         :integer          not null, primary key
#  alert_id   :integer
#  state      :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Cappy
  module Models
    class Trigger < ActiveRecord::Base
      self.table_name = 'triggers'

      belongs_to :alert
    end
  end
end
