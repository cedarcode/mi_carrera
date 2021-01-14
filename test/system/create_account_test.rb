require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  setup do
    visit visitor_home_index_path
  end

  test "user can see a google sign in button" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_selector "button", text: 'Registrarse con Google'
  end
end
