class AddTaskForSchedules < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :device_id, null: false
      t.decimal :state, null: false, precision: 2, scale: 1
    end

    remove_column :schedules, :device_id
    add_column :schedules, :task_id, :integer
  end
end
