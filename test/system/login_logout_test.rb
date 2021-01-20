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
    visit new_session_path

    assert_text "Iniciar sesión con tu correo electrónico"
    fill_in "Correo electrónico", with: 'bob@test.com'
    fill_in "Contraseña", with: 'bob12345'
    click_on "Iniciar sesión"

    assert_current_path(root_path)
    assert_text "Student"
    assert_selector "a", text: "person"
    assert_text "bob@test.com"
  end

  test "user can't sign in if enters wrong password" do
    visit new_session_path

    assert_text "Iniciar sesión con tu correo electrónico"
    fill_in "Correo electrónico", with: 'bob@test.com'
    fill_in "Contraseña", with: 'bob54321'
    click_on "Iniciar sesión"

    assert_text "Ocurrió un error al iniciar sesión"
  end
end
