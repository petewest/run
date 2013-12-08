class Post < ActiveRecord::Base
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: {minimum: 4}
  validates :at, presence: true

  
  belongs_to :user
  belongs_to :category
end
