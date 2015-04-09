class AddAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :name
    end

    create_table :triggers do |t|
      t.integer :alert_id, null: true
      t.boolean :state
    end

    add_column :devices, :alert_id, :integer, null: true
  end
end
