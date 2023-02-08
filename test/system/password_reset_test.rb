require "application_system_test_case"

class PasswordResetTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @user = create :user
  end

  test "successfully resets password" do
    visit new_user_password_path
    fill_in "Correo electrónico", with: @user.email

    assert_emails(1) do
      click_on "Restablecer contraseña"
      assert_text "Recibirás un email con instrucciones para reiniciar tu contraseña en unos minutos."
    end

    # This is the link that should be part of the password reset email sent
    # to the user
    reset_password_token = @user.send_reset_password_instructions
    visit edit_user_password_path(reset_password_token: reset_password_token)

    fill_in "Nueva contraseña", with: "newalice"
    click_on "Restablecer contraseña"
    assert_text 'Tu contraseña fue modificada correctamente. Has iniciado sesión.'

    # now lets check that the user can login with the new password
    click_actions_menu
    click_on "Salir"
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "newalice"
  end

  test "fails to reset if token is invalid" do
    visit edit_user_password_path(t: "whatever")

    assert_text "No puedes acceder a esta página sin venir desde el email de reinicio de contraseña." +
                " Si vienes desde ahí, por favor asegúrate de usar la url completa que aparece."
    assert_current_path new_user_session_path
  end

  test "doesn't send email to user" do
    visit new_user_password_path

    fill_in "Correo electrónico", with: "non-existent@test.com"

    assert_no_emails do
      click_on "Restablecer contraseña"
      assert_text "No encontrado"
    end
  end
end
