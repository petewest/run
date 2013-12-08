class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :ip_addr
      t.boolean :permanent
      t.string :remember_token
      t.integer :user_id

      t.timestamps
    end
    add_index :sessions, [:user_id, :remember_token]
  end
end
