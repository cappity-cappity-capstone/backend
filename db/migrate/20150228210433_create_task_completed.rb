class CreateTaskCompleted < ActiveRecord::Migration
  def change
    create_table :task_complete do |t|
      t.timestamps
    end
  end
end
