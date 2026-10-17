require 'rails_helper'

RSpec.describe 'Manage passkeys' do
  include ActiveSupport::Testing::TimeHelpers

  let!(:user) { create(:user) }
  ENV['ENABLE_PASSKEYS'] = 'true'

  before do
    @authenticator = add_virtual_authenticator
  end

  after do
    @authenticator.remove!
  end

  describe 'Add passkey, login with it, and removing it' do
    it 'works correctly' do
      sign_in user

      visit edit_user_registration_path

      click_on "Administrar Passkeys"

      fill_in "Nombre", with: "My new passkey"
      click_on "Agregar Passkey"

      expect(page).to have_content "My new passkey"
      expect(page).to have_css ".material-icons", text: "delete"
      expect(page).to have_text "Tu passkey ha sido agregada correctamente"

      click_user_menu
      click_on 'Salir'

      expect(page).to have_text('Cerraste sesión correctamente')

      click_user_menu
      click_on 'Ingresar'

      click_on 'Ingresar con Passkey'

      expect(page).to have_text('Iniciaste sesión correctamente')

      click_user_menu
      expect(page).to have_text(user.email)

      visit edit_user_registration_path

      # The grant the sign-in wrote expires, so the next visit is interrupted.
      travel Devise.reauthentication_period + 1.minute
      click_on "Administrar Passkeys"

      expect(page).to have_text "Verifica tu identidad"

      fill_in "Contraseña", with: "wrong password"
      click_on "Confirmar"

      expect(page).to have_text "No pudimos verificar tu identidad"

      fill_in "Contraseña", with: user.password
      click_on "Confirmar"

      expect(page).to have_text "Administra tus Passkeys"

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

  def add_virtual_authenticator
    options = ::Selenium::WebDriver::VirtualAuthenticatorOptions.new
    options.user_verification = true
    options.user_verified = true
    options.resident_key = true
    page.driver.browser.add_virtual_authenticator(options)
  end
end
