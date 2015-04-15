class UpdateStateType < ActiveRecord::Migration
  def change
    change_column :states, :state, :decimal, precision: 10, scale: 10
  end
end
