require 'rails_helper'

RSpec.describe 'Manage passkeys' do
  before do
    ENV['ENABLE_PASSKEYS'] = 'true'
  end

  describe 'Add and remove credentials' do
    let(:user) { create(:user) }

    it 'works correctly' do
      fake_origin = Rails.configuration.webauthn_origin[0]
      fake_client = WebAuthn::FakeClient.new(fake_origin, encoding: false)
      fixed_challenge = SecureRandom.random_bytes(32)
      fake_credentials = fake_client.create(challenge: fixed_challenge, user_verified: true)

      allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge)
        .and_return(fixed_challenge)

      sign_in user

      visit edit_user_registration_path

      click_on "Administrar Passkeys"

      stub_create(fake_credentials)

      fill_in "Nombre", with: "My new passkey"
      fill_in "Contraseña actual", with: user.password
      click_on "Agregar Passkey"

      expect(page).to have_content "My new passkey"
      expect(page).to have_css ".material-icons", text: "delete"
      expect(page).to have_text "Tu passkey ha sido agregada correctamente"

      within("li", text: "My new passkey") do
        accept_confirm "¿Seguro que quieres borrar esta Passkey?" do
          find(".material-icons", text: "delete").click
        end
      end

      expect(page).to have_no_content "My new passkey"
      expect(page).to have_text "Tu passkey ha sido eliminada correctamente"
    end

    it 'alerts wrong password' do
      fake_origin2 = Rails.configuration.webauthn_origin[0]
      fake_client2 = WebAuthn::FakeClient.new(fake_origin2, encoding: false)
      fixed_challenge2 = SecureRandom.random_bytes(32)
      fake_credentials2 = fake_client2.create(challenge: fixed_challenge2, user_verified: true)

      allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge)
        .and_return(fixed_challenge2)

      sign_in user

      visit edit_user_registration_path

      click_on "Administrar Passkeys"

      stub_create(fake_credentials2)

      fill_in "Nombre", with: "My new passkey"
      fill_in "Contraseña actual", with: "Incorrect Password!"
      click_on "Agregar Passkey"

      expect(page).to have_text "Contraseña Incorrecta"
      expect(page).to have_no_content "Tu passkey ha sido agregada correctamente"
    end
  end
end
