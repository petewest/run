class Post < ActiveRecord::Base
  before_save {self.stub||=title.parameterize}
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: {minimum: 4}
  
  #set the default sort order 
  default_scope -> { order('created_at DESC')}
  
  def to_param
    "#{id} #{stub}".parameterize
  end
  
  belongs_to :user
  belongs_to :category
end
