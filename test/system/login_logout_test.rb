require "application_system_test_case"

class LoginLogoutTest < ApplicationSystemTestCase
  setup do
    visit root_path
    click_on "¡Probar la app!"

    create_user
  end

  test "user can see sign in icon and google sign in button" do
    visit new_session_path

    assert_text "Ingreso"
    assert_selector "button", text: 'Ingresar con Google'
  end

  test "not signed in user can't see sign out link" do
    visit root_path
    click_on "more_vert"

    assert_no_text "Salir"
  end

  test "user can sign in with email and password" do
    visit new_session_path

    assert_text "Ingresar con tu correo electrónico"
    fill_in "Correo electrónico", with: 'bob@test.com'
    fill_in "Contraseña", with: 'bob123'
    click_on "Ingresar"

    assert_current_path(root_path)
    assert_text "Student"
    assert_text "bob@test.com"
  end

  test "user can't sign in if enters wrong password" do
    visit new_session_path

    assert_text "Ingresar con tu correo electrónico"
    fill_in "Correo electrónico", with: 'bob@test.com'
    fill_in "Contraseña", with: 'bob321'
    click_on "Ingresar"

    assert_text "Ocurrió un error al ingresar"
  end
end
