class ActivityType < ActiveRecord::Base
  validates :name, presence: true
end
