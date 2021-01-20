require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  setup do
    visit root_path
    click_on "¡Probar la app!"
  end

  test "user can see a google sign in button" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_selector "button", text: 'Registrarse con Google'
  end
end
