class AddAlertIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :alert_id, :string
  end
end
