require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  test "user can see a google sign in button" do
    visit account_path
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_selector "button", text: 'Registrarse con Google'
  end
end
