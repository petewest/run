class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  before_validation { self.gravatar_email||=email.downcase }
  before_validation { self.gravatar_email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :gravatar_email, presence: true, format: { with: VALID_EMAIL_REGEX }
    
  has_secure_password
  validates :password, length: { minimum: 6 }
  
end
