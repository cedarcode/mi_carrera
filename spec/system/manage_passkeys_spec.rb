require 'rails_helper'

RSpec.describe 'Manage passkeys' do
  before do
    sign_in create(:user)
  end

  ENV['ENABLE_PASSKEYS'] = 'true'

  describe 'Add and remove credentials' do
    fake_origin = Rails.configuration.webauthn_origin[0]
    fake_client = WebAuthn::FakeClient.new(fake_origin, encoding: false)
    fixed_challenge = SecureRandom.random_bytes(32)
    fake_credentials = fake_client.create(challenge: fixed_challenge, user_verified: true)

    it 'works correctly' do
      allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge)
        .and_return(fixed_challenge)

      visit edit_user_registration_path

      click_on "Administrar Passkeys"

      stub_create(fake_credentials)

      fill_in "Nombre", with: "My new passkey"
      click_on "Agregar Passkey"

      expect(page).to have_content "My new passkey"
      expect(page).to have_text "Tu passkey ha sido agregada correctamente"

      within("li", text: "My new passkey") do
        accept_confirm "¿Seguro que quieres borrar esta Passkey?" do
          find("svg").click
        end
      end

      expect(page).to have_no_content "My new passkey"
      expect(page).to have_text "Tu passkey ha sido eliminada correctamente"
    end
  end
end
