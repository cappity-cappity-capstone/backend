class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,      null: false
      t.string :password_hash, null: false
      t.timestamps             null: false

      t.index :username, unique: true
    end
  end
end
