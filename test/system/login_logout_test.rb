require "application_system_test_case"

class LoginLogoutTest < ApplicationSystemTestCase
  test "user can see log in icon and google log in button" do
    visit root_path
    click_on "person"
    click_on "login"

    assert_text "Iniciar sesión"
    assert_selector "button", text: 'Iniciar sesión con Google'
  end

  test "not logged in user can't see log out link" do
    visit root_path
    click_on "person"

    assert_no_text "Cerrar sesión"
  end
end
