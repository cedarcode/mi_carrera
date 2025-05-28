require 'rails_helper'

RSpec.describe 'Manage passkeys' do
  let!(:user) { create(:user) }

  describe 'Add and remove credentials' do
    fake_origin = Rails.configuration.webauthn_origin
    fake_client = WebAuthn::FakeClient.new(fake_origin, encoding: false)
    fixed_challenge = SecureRandom.random_bytes(32)
    fake_credentials = fake_client.create(challenge: fixed_challenge, user_verified: true)

    it 'works correctly' do
      allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge)
        .and_return(fixed_challenge)

      sign_in user
      visit user_passkeys_path

      stub_create(fake_credentials)

      fill_in "credential_name", with: "My new passkey"
      click_on "Agregar Passkey"

      expect(page).to have_current_path user_passkeys_path
      expect(page).to have_content "My new passkey"

      within("li", text: "My new passkey") do
        accept_confirm "¿Seguro que quieres borrar esta Passkey?" do
          find("svg").click
        end
      end

      expect(page).to have_current_path user_passkeys_path
      expect(page).to have_no_content 'My new passkey'
    end
  end
end
