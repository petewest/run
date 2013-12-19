class AddFaceBookCommentsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :facebook_comments, :boolean, default: false
  end
end
