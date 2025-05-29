require 'rails_helper'
require 'support/form_fields_helpers'
require 'support/password_helper'

RSpec.describe 'User', type: :system do
  include FormFieldHelpers
  include PasswordHelper

  it 'can sign up' do
    user = create(:user)

    visit new_user_session_path

    click_on 'Registrarte'
    expect(page).to have_text('Registrarse')

    expect(page).to have_text('Google')

    password = Devise.friendly_token
    fill_in 'Correo electrónico', with: 'alice@test.com'
    fill_in 'Contraseña', with: password
    fill_in 'Confirma tu contraseña', with: "incorrect#{password}"
    click_on 'Registrarte'

    within_form_field('Confirma tu contraseña') do
      assert_text "No coincide"
    end

    password = Devise.friendly_token
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: password
    fill_in 'Confirma tu contraseña', with: password
    click_on 'Registrarte'

    within_form_field('Correo electrónico') do
      assert_text "Ya está en uso"
    end

    fill_in 'Correo electrónico', with: 'alice@test.com'
    password = Devise.friendly_token
    fill_in 'Contraseña', with: password
    fill_in 'Confirma tu contraseña', with: password
    password_visibility_toggle_test('Contraseña')
    password_visibility_toggle_test('Confirma tu contraseña')
    click_on 'Registrarte'

    expect(page).to have_text('Bienvenido! Te has registrado correctamente.')

    click_user_menu
    expect(page).to have_text('alice@test.com')
  end

  it 'can reset password' do
    user = create(:user)

    visit new_user_session_path

    click_on 'Restablecer contraseña'
    fill_in 'Correo electrónico', with: 'non-existent@test.com'

    expect do
      click_on 'Restablecer contraseña'
    end.not_to send_email(to: 'non-existent@test.com')

    expect(page).to have_text('No encontrado')

    fill_in 'Correo electrónico', with: user.email
    expect do
      click_on 'Restablecer contraseña'
      expect(page).to have_text('Recibirás un email con instrucciones para reiniciar tu contraseña en unos minutos.')
    end.to send_email(to: user.email)

    visit edit_user_password_path(t: 'invalid')

    expect(page).to have_text('No puedes acceder a esta página sin venir desde el email de reinicio de contraseña. ' \
                             'Si vienes desde ahí, por favor asegúrate de usar la url completa que aparece.')

    visit edit_user_password_path(reset_password_token: user.send_reset_password_instructions)

    password = Devise.friendly_token
    fill_in 'Nueva contraseña', with: password
    password_visibility_toggle_test('Nueva contraseña')
    click_on 'Restablecer contraseña'
    expect(page).to have_text('Tu contraseña fue modificada correctamente. Has iniciado sesión.')

    click_user_menu
    click_on 'Salir'

    expect(page).to have_text('Cerraste sesión correctamente')

    click_user_menu
    click_on 'Ingresar'

    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: password

    click_on 'Ingresar'
    expect(page).to have_text('Iniciaste sesión correctamente')

    click_user_menu
    expect(page).to have_text(user.email)
  end

  it 'can login' do
    user = create(:user)

    visit new_user_session_path

    expect(page).to have_text('Iniciar sesión')
    expect(page).to have_text('Google')

    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: "incorrect#{user.password}"
    click_on 'Ingresar'

    expect(page).to have_text('Email y/o contraseña inválidos.')

    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    password_visibility_toggle_test('Contraseña')
    click_on 'Ingresar'

    click_user_menu
    expect(page).to have_text(user.email)
  end

  it 'can edit profile' do
    user = create(:user)
    user2 = create(:user)

    visit new_user_session_path
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_on 'Ingresar'
    expect(page).to have_text('Iniciaste sesión correctamente')

    click_user_menu
    click_on 'Editar Perfil'

    fill_in 'Contraseña actual', with: "incorrect#{user.password}"
    click_on 'Guardar'
    within_form_field('Contraseña actual') do
      assert_text "No es válido"
    end

    fill_in 'Contraseña actual', with: user.password
    three_char_long_password = Devise.friendly_token.first(3)
    fill_in 'Nueva contraseña', with: three_char_long_password
    fill_in 'Confirma tu nueva contraseña', with: three_char_long_password
    click_on 'Guardar'

    within_form_field('Confirma tu nueva contraseña') do
      assert_text "Es demasiado corto (6 caracteres mínimo)"
    end

    password = Devise.friendly_token
    fill_in 'Nueva contraseña', with: password
    fill_in 'Confirma tu nueva contraseña', with: "incorrect#{password}"
    fill_in 'Contraseña actual', with: user.password
    click_on 'Guardar'

    within_form_field('Confirma tu nueva contraseña') do
      assert_text "No coincide"
    end

    fill_in 'Correo electrónico', with: user2.email
    fill_in 'Contraseña actual', with: user.password
    click_on 'Guardar'

    within_form_field('Correo electrónico') do
      assert_text "Ya está en uso"
    end

    new_password = Devise.friendly_token
    fill_in 'Nueva contraseña', with: new_password
    fill_in 'Confirma tu nueva contraseña', with: new_password
    fill_in 'Contraseña actual', with: user.password
    password_visibility_toggle_test('Nueva contraseña')
    password_visibility_toggle_test('Confirma tu nueva contraseña')
    password_visibility_toggle_test('Contraseña actual')
    fill_in 'Correo electrónico', with: "new_#{user.email}"
    click_on 'Guardar'
    expect(page).to have_text('Actualizaste tu cuenta correctamente.')

    click_user_menu
    expect(page).to have_text("new_#{user.email}")
  end

  private

  def click_user_menu
    find("#user-menu[data-controller-connected='true']").click
  end
end
