class BasicAuth < ApplicationRecord
  validates :username, presence: true
  validates :password_digest, presence: true
  validates_uniqueness_of :username
  has_secure_password

  def self.find_by_username_and_password(username:, password:)
    basic_auth = find_by(username: username)
    if basic_auth&.authenticate(password)
      basic_auth
    else
      nil
    end
  end
end
