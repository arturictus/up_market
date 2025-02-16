class Buyer < ApplicationRecord
  validates_presence_of :basic_auth, :name
  belongs_to :basic_auth

  def self.create_with_basic_auth!(name:, username:, password:)
    transaction do
      basic_auth = BasicAuth.create!(username: username, password: password)
      create!(name: name, basic_auth: basic_auth)
    end
  end

  def self.find_by_username_and_password(username:, password:)
    if basic_auth = BasicAuth.find_by_username_and_password(username: username, password: password)
      find_by(basic_auth: basic_auth)
    else
      nil
    end
  end
end
