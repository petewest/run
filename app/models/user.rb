class User < ActiveRecord::Base
  before_save { email.downcase! }
  
  #If we don't have a gravatar email present then copy the email address before
  #we validate the record
  before_validation { self.gravatar_email||=email.downcase }
  
  #as the email.downcase! doesn't run until before_save we'd
  #end up copying it in anycase form, so we'll downcase it too
  before_save { gravatar_email.downcase! }
  
  #make sure we've got a remember token on create
  before_create :create_remember_token
  
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :gravatar_email, presence: true, format: { with: VALID_EMAIL_REGEX }
    
  has_secure_password
  validates :password, length: { minimum: 6 }


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
