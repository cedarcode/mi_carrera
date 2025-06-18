class Passkey < ApplicationRecord
  belongs_to :user

  validates :external_id, :public_key, :name, :sign_count, presence: true
  validates :external_id, uniqueness: true
  validates :sign_count, numericality: { only_integer: true, in: 0..2**32 - 1 }
end

# == Schema Information
#
# Table name: passkeys
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  public_key  :string           not null
#  sign_count  :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_passkeys_on_external_id  (external_id) UNIQUE
#  index_passkeys_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
