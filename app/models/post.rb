class Post < ActiveRecord::Base
  before_save {self.stub||=title.parameterize if !draft}
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: {minimum: 4}
  
  #set the default sort order 
  default_scope -> { order('created_at DESC') }
  
  scope :not_draft, -> { where(draft: false) }
  
  def to_param
    "#{id} #{stub}".parameterize
  end

  ##
  # Relationships
  belongs_to :user
  belongs_to :category
  has_many :hits, as: :hittable, dependent: :destroy
end
