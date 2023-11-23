class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :approvals, type: Array

  def self.from_omniauth(auth, cookie)
    # check that user with same email exists
    existing_user = User.find_by(email: auth.info.email)

    if existing_user
      # if user exists, update the uid and provider
      existing_user.update(uid: auth.uid, provider: auth.provider)
      existing_user
    else
      # if user doesn't exist, create a new user
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.approvals = JSON.parse(cookie[:approved_approvable_ids] || "[]")
        user.welcome_banner_viewed = cookie[:welcome_banner_viewed] == "true"
      end
    end
  end

  def remember_me = true

  def oauth_user?
    provider.present?
  end
end
