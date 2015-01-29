class AddUnitToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :unit, :string
  end
end
