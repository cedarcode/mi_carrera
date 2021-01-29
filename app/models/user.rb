require "securerandom"

class User < ApplicationRecord
  validates :email_address, presence: true, uniqueness: true
  serialize :approvals, Hash

  has_secure_password validations: false
  validates :password, confirmation: true, length: { minimum: 8 }, allow_blank: true

  def generate_password_reset_token
    self.password_reset_token = SecureRandom.hex(32)
  end
end
