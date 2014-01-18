class AddDistanceSeriesToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :distance_series, :text
  end
end
