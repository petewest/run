class Activity < ActiveRecord::Base
  validates :start_time, presence: true
  validates :user_id, presence: true
  
  before_save :create_polyline
  
  belongs_to :user
  belongs_to :activity_type
  
  private
  def create_polyline
    self.polyline=Polylines::Encoder.encode_points(JSON::parse(self.lat_long_series).select {|x| x!=[nil,nil] })
  end
end
