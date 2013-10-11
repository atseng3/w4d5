class User < ActiveRecord::Base
  attr_accessible :username, :password

  validates :username, :presence => true, :uniqueness => true
  validates :password_digest, :presence => { :message => "Password can't be blank"}

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
  end

  def password=(pass)
    self.password_digest = BCrypt::Password.create(pass)
    self.save!
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

  def self.find_by_credentials(username, password)
    u = User.where("username = ?", username).first
    if u.is_password?(password)
      return u
    else
      nil
    end
  end
end