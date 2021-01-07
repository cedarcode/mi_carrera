require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  test "user can see a google sign in button" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Registro"
    assert_selector "button", text: 'Registrarte con Google'
  end
end
