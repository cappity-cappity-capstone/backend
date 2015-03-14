class AddIpAddressToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :ip_address, :string, null: true
  end
end
