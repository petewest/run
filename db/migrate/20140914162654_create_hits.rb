class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.references :hittable, polymorphic: true, index: true
      t.string :ip_address
      t.integer :impressions

      t.timestamps
    end
  end
end
