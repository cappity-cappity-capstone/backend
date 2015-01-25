class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id, null: false
      t.string :name, null: false
      t.string :device_type, null: false
      t.datetime :last_check_in, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      
      t.index :device_id
    end
  end
end