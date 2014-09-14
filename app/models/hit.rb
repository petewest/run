class Hit < ActiveRecord::Base
  ##
  # Validations
  validates :ip_address, presence: true
  validates :hittable, presence: true

  ##
  # Callbacks
  after_initialize { self.impressions ||= 0 }

  ##
  # Relationships
  belongs_to :hittable, polymorphic: true
end
