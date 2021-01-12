class User < ApplicationRecord
  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  serialize :approvals, Hash

  has_secure_password
  validates :password_digest, presence: true,
                              confirmation: true,
                              on: :create
end
