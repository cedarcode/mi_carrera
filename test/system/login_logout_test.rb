require "application_system_test_case"

class LoginLogoutTest < ApplicationSystemTestCase
  setup do
    visit root_path
    @user = create :user
  end

  test "user can see sign in icon and google sign in button" do
    visit new_user_session_path
    assert_text "Ingreso"
    assert_selector(:xpath, './/button[@class="google-sign-in-button"]')
  end

  test "not signed in user can't see sign out link" do
    visit root_path
    assert_no_text "Salir"
  end

  test "user can sign in with email and password" do
    visit new_user_session_path

    assert_text "Ingresar con tu correo electrónico"
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: @user.password
    click_on "Ingresar"

    assert_current_path(root_path)
    assert_text "MiCarrera"
    click_actions_menu
    within_actions_menu do
      assert_text @user.email
    end
  end

  test "user can't sign in if enters wrong password" do
    visit new_user_session_path

    assert_text "Ingresar con tu correo electrónico"
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: 'incorrect'
    click_on "Ingresar"

    assert_text "Email y/o contraseña inválidos."
  end
end
