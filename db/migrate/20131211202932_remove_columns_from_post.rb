class RemoveColumnsFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :embed_code
    remove_column :posts, :at
  end
end
