class UpdateStateType < ActiveRecord::Migration
  def change
    change_column :states, :state, :decimal, precision: 2, scale: 1
  end
end
