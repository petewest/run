class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :stub
      t.integer :sort_order

      t.timestamps
    end
    add_index :categories, [:stub, :sort_order], unique: true, order: {sort_order: :asc}
  end
end
