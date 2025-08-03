require 'rails_helper'

RSpec.describe 'Manage passkeys' do
  let!(:user) { create(:user) }
  ENV['ENABLE_PASSKEYS'] = 'true'

  describe 'Add passkey, login with it, and removing it' do
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
      click_on "Agregar Passkey"

      expect(page).to have_content "My new passkey"
      expect(page).to have_css ".material-icons", text: "delete"
      expect(page).to have_text "Tu passkey ha sido agregada correctamente"

      click_user_menu
      click_on 'Salir'

      expect(page).to have_text('Cerraste sesión correctamente')

      fake_assertion = fake_client.get(challenge: fixed_challenge, user_verified: true)

      allow_any_instance_of(WebAuthn::PublicKeyCredential::RequestOptions).to receive(:raw_challenge)
        .and_return(fixed_challenge)

      click_user_menu
      click_on 'Ingresar'

      stub_get(fake_assertion)
      click_on 'Ingresar con Passkey'

      expect(page).to have_text('Iniciaste sesión correctamente')

      click_user_menu
      expect(page).to have_text(user.email)

      visit edit_user_registration_path

      click_on "Administrar Passkeys"

      within("li", text: "My new passkey") do
        accept_confirm "¿Seguro que quieres borrar esta Passkey?" do
          find(".material-icons", text: "delete").click
        end
      end

      expect(page).to have_no_content "My new passkey"
      expect(page).to have_text "Tu passkey ha sido eliminada correctamente"
    end
  end

  private

  def click_user_menu
    find("#user-menu[data-controller-connected='true']").click
  end
end
