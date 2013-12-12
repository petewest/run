class Activity < ActiveRecord::Base
  validates :start_time, presence: true
  validates :user_id, presence: true

  belongs_to :user
  belongs_to :activity_type
end
