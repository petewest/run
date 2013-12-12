class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.datetime :start_time
      t.float :distance
      t.integer :duration
      t.float :height_gain
      t.text :polyline
      t.text :time_series
      t.text :elevation_series
      t.text :hr_series
      t.text :pace_series
      t.text :gpx
      t.references :activity_type
      t.references :user

      t.timestamps
    end
    add_index :activities, [:user_id, :start_time]
  end
end
