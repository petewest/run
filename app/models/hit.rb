class Hit < ActiveRecord::Base
  ##
  # Validations
  validates :ip_address, presence: true, uniqueness: { scope: :hittable }
  validates :hittable, presence: true

  ##
  # Callbacks
  after_initialize { self.impressions ||= 0 }

  ##
  # Methods
  def increment_impressions!
    self.impressions += 1
    save!
  end

  ##
  # Relationships
  belongs_to :hittable, polymorphic: true, counter_cache: true
end
