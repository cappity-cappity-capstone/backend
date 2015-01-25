class DeleteLocks < ActiveRecord::Migration
  def change
    drop_table :locks
  end
end
