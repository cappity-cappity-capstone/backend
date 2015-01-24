class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.string :name, null: false
      t.string :device_id, null: false
      t.boolean :status, null: false

      t.index :device_id
    end
  end
end
