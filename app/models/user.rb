class User < ActiveRecord::Base
  before_save { email.downcase! }
  
  #If we don't have a gravatar email present then copy the email address before
  #we validate the record
  before_validation { self.gravatar_email||=email.downcase }
  
  #as the email.downcase! doesn't run until before_save we'd
  #end up copying it in anycase form, so we'll downcase it too
  before_save { gravatar_email.downcase! }
    
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :gravatar_email, presence: true, format: { with: VALID_EMAIL_REGEX }
    
  has_secure_password
  validates :password, length: { minimum: 6 }, if: :check_password?


  private
  def check_password?
    #Basic check here for now
    #Only validate password for new user to allow edits without requiring password
    #TODO think of a better solution that'll allow password changes
    self.new_record?
  end
  
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :attachments, dependent: :destroy
end
