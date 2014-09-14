class AddHitsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hits_count, :integer, default: 0, null: false
  end
end
