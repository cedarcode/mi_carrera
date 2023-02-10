class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :approvals, Array

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
        user.add_approvals_in_cookie(cookie)
        user.welcome_banner_viewed = true
      end
    end
  end

  def remember_me = true

  def oauth_user?
    provider.present?
  end

  def add_approvals_in_cookie(cookie)
    self.approvals = cookie_to_hash(cookie[:approved_approvable_ids])
    save!
  end

  private

  def cookie_to_hash(cookie)
    cookie.is_a?(String) ? cookie.split('&').map(&:to_i) : []
  end
end
