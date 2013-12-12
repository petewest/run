class Activity < ActiveRecord::Base
  validates :start_time, presence: true
  validates :user_id, presence: true

  serialize :time_series
  serialize :elevation_series
  serialize :hr_series
  serialize :pace_series
  serialize :gpx
  
  
  belongs_to :user
  belongs_to :activity_type
end
