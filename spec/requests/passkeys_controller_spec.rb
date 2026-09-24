require 'rails_helper'

RSpec.describe Users::PasskeysController, type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  let(:passkey) do
    user.passkeys.create!(external_id: 'external-id', name: 'A passkey', public_key: 'public-key', sign_count: 0)
  end
  ENV['ENABLE_PASSKEYS'] = 'true'

  describe 'the re-authentication gate' do
    before do
      sign_in user

      # Signing in writes a grant, so this request is never interrupted.
      get user_passkeys_path
    end

    it 'lets a user who has just signed in through' do
      expect(response).to have_http_status(:ok)
    end

    it 'challenges a user whose grant has expired on GET index' do
      travel Devise.reauthentication_period + 1.minute

      get user_passkeys_path

      expect(response).to redirect_to(new_user_reauthentication_path)
    end

    it 'challenges a user whose grant has expired on POST create' do
      travel Devise.reauthentication_period + 1.minute

      expect do
        post user_passkeys_path, params: { public_key_credential: '{}', name: 'A new passkey' }
      end.not_to change(user.passkeys, :count)

      expect(response).to redirect_to(new_user_reauthentication_path)
    end

    it 'challenges a user whose grant has expired on DELETE destroy' do
      path = user_passkey_path(passkey)
      travel Devise.reauthentication_period + 1.minute

      expect do
        delete path
      end.not_to change(user.passkeys, :count)

      expect(response).to redirect_to(new_user_reauthentication_path)
    end

    it 'slides the window forward on every gated request' do
      travel 10.minutes
      get user_passkeys_path
      expect(response).to have_http_status(:ok)

      # 20 minutes after signing in, but only 10 after the request above.
      travel 10.minutes
      get user_passkeys_path
      expect(response).to have_http_status(:ok)

      travel Devise.reauthentication_period + 1.minute
      get user_passkeys_path
      expect(response).to redirect_to(new_user_reauthentication_path)
    end
  end
end
