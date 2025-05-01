require "application_system_test_case"

SimpleCov.command_name "Minitest:system"

class UserTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper
  include PasswordHelpers

  test "can sign up" do
    user = create :user

    visit new_user_session_path

    click_on "Registrarte"
    assert_text "Registro"

    assert_text "Continuar con Google"

    password = Devise.friendly_token
    fill_in "Correo electrónico", with: 'alice@test.com'
    fill_in "Contraseña", with: password
    fill_in "Confirma tu contraseña", with: "incorrect#{password}"
    click_on "Registrarte"

    within('.form-input-container', text: 'Confirma tu contraseña') do
      assert_text "No coincide"
    end

    password = Devise.friendly_token
    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: password
    fill_in "Confirma tu contraseña", with: password
    click_on "Registrarte"

    within('.form-input-container', text: 'Correo electrónico') do
      assert_text "Ya está en uso"
    end

    fill_in "Correo electrónico", with: 'alice@test.com'
    password = Devise.friendly_token
    fill_in "Contraseña", with: password
    fill_in "Confirma tu contraseña", with: password
    password_visibility_toggle_test("Contraseña")
    password_visibility_toggle_test("Confirma tu contraseña")
    click_on "Registrarte"

    assert_text "Bienvenido! Te has registrado correctamente."

    click_user_menu
    assert_text "alice@test.com"
  end

  test "can reset password" do
    user = create :user

    visit new_user_session_path

    click_on "Restablecer contraseña"
    fill_in "Correo electrónico", with: "non-existent@test.com"

    assert_no_emails do
      click_on "Restablecer contraseña"
    end
    assert_text "No encontrado"

    fill_in "Correo electrónico", with: user.email
    assert_emails(1) do
      click_on "Restablecer contraseña"
      assert_text "Recibirás un email con instrucciones para reiniciar tu contraseña en unos minutos."
    end

    visit edit_user_password_path(t: "invalid")

    assert_text "No puedes acceder a esta página sin venir desde el email de reinicio de contraseña." +
                " Si vienes desde ahí, por favor asegúrate de usar la url completa que aparece."
    assert_current_path new_user_session_path

    visit edit_user_password_path(reset_password_token: user.send_reset_password_instructions)

    password = Devise.friendly_token
    fill_in "Nueva contraseña", with: password
    password_visibility_toggle_test("Nueva contraseña")
    click_on "Restablecer contraseña"
    assert_text 'Tu contraseña fue modificada correctamente. Has iniciado sesión.'

    click_user_menu
    click_on "Salir"

    assert_text "Cerraste sesión correctamente"

    click_user_menu
    click_on "Ingresar"

    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: password

    click_on "Ingresar"
    assert_text "Iniciaste sesión correctamente"

    click_user_menu
    assert_text user.email
  end

  test "can login" do
    user = create :user

    visit new_user_session_path

    assert_text "Ingreso"
    assert_text "Continuar con Google"

    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: "incorrect#{user.password}"
    click_on "Ingresar"

    assert_text "Email y/o contraseña inválidos."

    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: user.password
    password_visibility_toggle_test("Contraseña")
    click_on "Ingresar"

    assert_current_path(root_path)

    click_user_menu
    assert_text user.email
  end

  test "can edit profile" do
    user = create :user
    user2 = create :user

    visit new_user_session_path
    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: user.password
    click_on "Ingresar"
    assert_text "Iniciaste sesión correctamente"

    click_user_menu
    click_on "Editar Perfil"

    fill_in "Contraseña actual", with: "incorrect#{user.password}"
    click_on "Guardar"
    within('.form-input-container', text: 'Contraseña actual') do
      assert_text "No es válido"
    end

    fill_in "Contraseña actual", with: user.password
    three_char_long_password = Devise.friendly_token.first(3)
    fill_in "Nueva contraseña", with: three_char_long_password
    fill_in "Confirma tu nueva contraseña", with: three_char_long_password
    click_on "Guardar"
    within('.form-input-container', text: 'Nueva contraseña') do
      assert_text "Es demasiado corto (6 caracteres mínimo)"
    end

    password = Devise.friendly_token
    fill_in "Nueva contraseña", with: password
    fill_in "Confirma tu nueva contraseña", with: "incorrect#{password}"
    fill_in "Contraseña actual", with: user.password
    click_on "Guardar"
    within('.form-input-container', text: 'Confirma tu nueva contraseña') do
      assert_text "No coincide"
    end

    fill_in 'Correo electrónico', with: user2.email
    fill_in 'Contraseña actual', with: user.password
    click_on 'Guardar'
    within('.form-input-container', text: 'Correo electrónico') do
      assert_text "Ya está en uso"
    end

    new_password = Devise.friendly_token
    fill_in "Nueva contraseña", with: new_password
    fill_in "Confirma tu nueva contraseña", with: new_password
    fill_in "Contraseña actual", with: user.password
    password_visibility_toggle_test("Nueva contraseña")
    password_visibility_toggle_test("Confirma tu nueva contraseña")
    password_visibility_toggle_test("Contraseña actual")
    fill_in "Correo electrónico", with: "new_#{user.email}"
    click_on "Guardar"
    assert_text "Actualizaste tu cuenta correctamente."

    click_user_menu
    assert_text "new_#{user.email}"
  end
end
