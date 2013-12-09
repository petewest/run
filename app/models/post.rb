class Post < ActiveRecord::Base
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: {minimum: 4}
  validates :at, presence: true
  
  #set the default sort order 
  default_scope -> { order('at DESC')}
  
  belongs_to :user
  belongs_to :category
end
