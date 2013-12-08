class Category < ActiveRecord::Base
  before_save { stub.downcase! }
  validates :name, presence: true
  VALID_STUB_REGEX=/\A[\w+\-.]+\z/i
  validates :stub, presence:true, uniqueness: { case_sensitive: false }, length: {maximum:20}, format: {with: VALID_STUB_REGEX}
  
  #set the default sort order 
  default_scope -> { order('sort_order ASC')}
  
  has_many :posts, dependent: :destroy
end
