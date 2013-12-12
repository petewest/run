class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
