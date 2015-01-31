class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string   :device_id,  null: false
      t.integer  :state,      null: false
      t.string   :source,     null: false
      t.timestamps            null: false

      t.index :device_id

      add_foreign_key :device_id, :devices
    end
  end
end
