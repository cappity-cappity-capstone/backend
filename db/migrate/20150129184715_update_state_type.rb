class UpdateStateType < ActiveRecord::Migration
  def change
    change_column :states, :state, :decimal
  end
end
