class AddLatLongSeriesToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :lat_long_series, :text
  end
end
