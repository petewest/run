class AddStubToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :stub, :string
  end
end
