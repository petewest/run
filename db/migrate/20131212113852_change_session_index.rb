class ChangeSessionIndex < ActiveRecord::Migration
  def change
	remove_index :sessions, [:user_id, :remember_token]
	add_index :sessions, :user_id
	add_index :sessions, :remember_token, unique: true
  end
end
