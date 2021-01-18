require "application_system_test_case"

class LoginLogoutTest < ApplicationSystemTestCase
  setup do
    create_user
  end

  test "user can see sign in icon and google sign in button" do
    visit root_path
    click_on "person"
    click_on "login"

    assert_text "Iniciar sesión"
    assert_selector "button", text: 'Iniciar sesión con Google'
  end

  test "not signed in user can't see sign out link" do
    visit root_path
    click_on "person"

    assert_no_text "Cerrar sesión"
  end

  test "user can sign in with email and password" do
    visit root_path
    click_on "person"
    click_on "login"

    assert_text "Iniciar sesión con tu correo electrónico"
    assert_selector "button", text: 'Iniciar sesión'
    fill_in "email", with: 'test@user.com'
    fill_in "password", with: '123456'
    click_on "Iniciar sesión"

    assert_text "test@user.com"
  end

  test "user can't sign in if enters wrong password" do
    visit root_path
    click_on "person"
    click_on "login"

    assert_text "Iniciar sesión con tu correo electrónico"
    assert_selector "button", text: 'Iniciar sesión'
    fill_in "email", with: 'test@user.com'
    fill_in "password", with: '654321'
    click_on "Iniciar sesión"

    assert_text "Ocurrió un error al iniciar sesión"
  end
end
