class User < ApplicationRecord
  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  serialize :approvals, Hash

  has_secure_password
  validates :password_digest, confirmation: true
end
