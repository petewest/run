class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :embed_code
      t.datetime :at
      t.text :write_up
      t.references :user, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
