class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :device_id, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.integer :interval, null: false
    end
  end
end
