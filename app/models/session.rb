class Session < ActiveRecord::Base
  belongs_to :user
  
  validates :remember_token, presence: true
  validates :user_id, presence: true
  validates :ip_addr, presence: true
  
  def Session.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Session.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
end
