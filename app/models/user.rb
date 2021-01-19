class User < ApplicationRecord
  validates :email_address, presence: true, uniqueness: true
  serialize :approvals, Hash

  has_secure_password validations: false
  validates :password, confirmation: true, on: :account_create
end
