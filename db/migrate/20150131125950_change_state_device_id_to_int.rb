class ChangeStateDeviceIdToInt < ActiveRecord::Migration
  def change
    change_column :states, :device_id, :int
  end
end
