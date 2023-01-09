class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :approvals, Hash

  def self.from_omniauth(auth)
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
      end
    end
  end

  def oauth_user?
    provider.present?
  end
end
