class WebauthnCredential < ApplicationRecord
  belongs_to :user
  validates :external_id, :public_key, :name, :sign_count, presence: true
  validates :external_id, uniqueness: true

  enum :authentication_factor, { first_factor: 0, second_factor: 1 }

  scope :passkey, -> { first_factor }
end

# == Schema Information
#
# Table name: webauthn_credentials
#
#  id                    :bigint           not null, primary key
#  authentication_factor :integer          not null
#  name                  :string           not null
#  public_key            :text             not null
#  sign_count            :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  external_id           :string           not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_webauthn_credentials_on_external_id  (external_id) UNIQUE
#  index_webauthn_credentials_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
