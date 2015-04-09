# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Cappy
  module Models
    class Alert < ActiveRecord::Base
      self.table_name = 'alerts'
      VALID_ALERT_TYPES = %w(airbourne_alert)

      validates :name, presence: true
      validates :type, presence: true, inclusion: { in: VALID_ALERT_TYPES }

      has_many :devices
      has_many :triggers
    end
  end
end
