require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    context 'when user does not exist' do
      it 'creates a new user' do
        auth = OmniAuth::AuthHash.new(
          provider: 'google',
          uid: '123456789',
          info: OmniAuth::AuthHash::InfoHash.new(
            email: 'user1@gmail.com'
          )
        )

        new_user = described_class.from_omniauth(auth, {})

        expect(new_user).to be_persisted
        expect(new_user.email).to eq(auth.info.email)
        expect(new_user.provider).to eq(auth.provider)
        expect(new_user.uid).to eq(auth.uid)
      end
    end

    context 'when user exists' do
      it 'updates the existing user' do
        user = create(:user)

        auth = OmniAuth::AuthHash.new(
          provider: 'google',
          uid: '123456789',
          info: OmniAuth::AuthHash::InfoHash.new(
            email: user.email
          )
        )

        existing_user = described_class.from_omniauth(auth, {})

        expect(existing_user).to be_persisted
        expect(existing_user.id).to eq(user.id)
        expect(existing_user.email).to eq(auth.info.email)
        expect(existing_user.provider).to eq(auth.provider)
        expect(existing_user.uid).to eq(auth.uid)
      end
    end
  end
end
