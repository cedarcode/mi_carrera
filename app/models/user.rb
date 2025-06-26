class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :approvals, type: Array, coder: YAML

  has_many :reviews, dependent: :destroy
  has_many :subject_plans, dependent: :destroy
  has_many :planned_subjects, through: :subject_plans, source: :subject
  belongs_to :degree
  has_many :passkeys, dependent: :destroy

  before_validation :set_default_degree

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

  def planned?(subject)
    subject_plans.any? { |subject_plan| subject_plan.subject_id == subject.id }
  end

  private

  def set_default_degree
    self.degree = Degree.default
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  approvals              :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  unlock_token           :string
#  welcome_banner_viewed  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  degree_id              :string           not null
#  webauthn_id            :string
#
# Indexes
#
#  index_users_on_degree_id             (degree_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (degree_id => degrees.id)
#
