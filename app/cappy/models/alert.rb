# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  alert_id   :string
#

module Cappy
  module Models
    # A type of device that sends triggers
    class Alert < ActiveRecord::Base
      self.table_name = 'alerts'
      # Definitely wouldn't ever use this name as a column
      self.inheritance_column = 'zoink'

      VALID_ALERT_TYPES = %w(airbourne_alert)

      validates :alert_id, presence: true
      validates :name, presence: true
      validates :type, presence: true, inclusion: { in: VALID_ALERT_TYPES }

      has_many :devices
      has_many :triggers
    end
  end
end
