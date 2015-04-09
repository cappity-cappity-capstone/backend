class AddAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.timestamps null: false
    end

    create_table :triggers do |t|
      t.integer :alert_id, null: true
      t.boolean :state, null: false
      t.timestamps null: false
    end

    add_column :devices, :alert_id, :integer, null: true
  end
end
