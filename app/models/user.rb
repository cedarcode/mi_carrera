class User < ApplicationRecord
  validates :email_address, presence: true, uniqueness: true
  serialize :approvals, Hash

  has_secure_password validations: false
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, on: :account_create
end
