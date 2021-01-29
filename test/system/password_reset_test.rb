require "application_system_test_case"

class PasswordResetTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @user = create_user(email: "alice@test.com", name: "Alice A")
  end

  test "successfully resets password" do
    visit new_password_reset_path

    fill_in "Correo electrónico", with: "alice@test.com"

    assert_emails(1) do
      click_on "Restablecer contraseña"

      assert_text "Se envió un correo electrónico a alice@test.com"
    end

    # This is the link that should be part of the password reset email sent
    # to the user
    @user.reload
    visit new_password_path(t: @user.password_reset_token)

    assert_text "alice@test.com"

    fill_in "Nueva contraseña", with: "newalice"
    fill_in "Confirma tu nueva contraseña", with: "newalice"

    click_on "Restablecer contraseña"

    fill_in "Correo electrónico", with: "alice@test.com"
    fill_in "Contraseña", with: "newalice"

    click_on "Ingresar"

    assert_text "Alice A"
  end

  test "fails if new password doesn't confirm" do
    @user.generate_password_reset_token
    @user.save!

    visit new_password_path(t: @user.password_reset_token)

    fill_in "Nueva contraseña", with: "newalice"
    fill_in "Confirma tu nueva contraseña", with: "newalice-with-typo"

    click_on "Restablecer contraseña"

    assert_text "Ocurrió un error al restablecer la contraseña"
    assert_current_path new_password_path(t: @user.password_reset_token)
  end

  test "fails to reset if token is invalid" do
    visit new_password_path(t: "whatever")

    assert_text "Student"
    assert_current_path root_path
  end

  test "doesn't hint about non existent user" do
    visit new_password_reset_path

    fill_in "Correo electrónico", with: "non-existent@test.com"

    assert_no_emails do
      click_on "Restablecer contraseña"

      assert_text "Se envió un correo electrónico a non-existent@test.com"
    end
  end
end
