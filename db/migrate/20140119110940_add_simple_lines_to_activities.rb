class AddSimpleLinesToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :simple_distance, :text
    add_column :activities, :simple_lat_long, :text
    add_column :activities, :simple_hr, :text
    add_column :activities, :simple_elevation, :text
    add_column :activities, :simple_time, :text
  end
end
