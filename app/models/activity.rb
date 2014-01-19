class Activity < ActiveRecord::Base
  validates :start_time, presence: true
  validates :user_id, presence: true
  
  before_save :simplify
  before_save :create_polyline
  
  belongs_to :user
  belongs_to :activity_type
  
  default_scope -> { order('start_time DESC')}
  
  serialize :simple_distance
  serialize :simple_hr
  serialize :simple_elevation
  serialize :simple_time
  serialize :simple_lat_long
  
  #Function to reduce the number of points in point_series
  #based on the distance_series delta being over threshold
  
  def Activity.reduce_by_distance(distance_series, point_series, threshold)
    last_point=0
    point_series.select.with_index do |point, i|
      if !distance_series[i]
        false
      #is it the first point? (i.e. index is 0)
      #or further than threshold from the last point?
      elsif i==0 || distance_series[i]-last_point>threshold
        last_point=distance_series[i]
        true
      else
        false
      end
    end
  end
  
  private
  def simplify
    #reduce the line to 500 points, by using distance / 500 to get our threshold
    distance_threshold=distance/500
    if distance_series
      distance_array=JSON::parse(distance_series)
      self.simple_distance=Activity.reduce_by_distance(distance_array, distance_array, distance_threshold)
      self.simple_hr=Activity.reduce_by_distance(distance_array, JSON::parse(hr_series), distance_threshold) if hr_series
      self.simple_elevation=Activity.reduce_by_distance(distance_array, JSON::parse(elevation_series), distance_threshold) if elevation_series
      self.simple_time=Activity.reduce_by_distance(distance_array, JSON::parse(time_series), distance_threshold) if time_series
      self.simple_lat_long=Activity.reduce_by_distance(distance_array, JSON::parse(lat_long_series), distance_threshold) if lat_long_series
    end
  end
  
  def create_polyline
    to_use=simple_lat_long ? simple_lat_long : JSON::parse(lat_long_series)
    self.polyline=Polylines::Encoder.encode_points(to_use.select {|x| x!=[nil,nil] }) if to_use
  end
  
end
