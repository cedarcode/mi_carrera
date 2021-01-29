require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  setup do
    visit root_path
    click_on "¡Probar la app!"
  end

  test "user can see a google sign in button" do
    visit root_path
    click_on "more_vert"
    click_on "Registrarte"

    assert_text "Registro"
    assert_selector "button", text: 'Registrarte con Google'
  end

  test "user can sign up with email and password" do
    visit new_account_path

    assert_text "Registrarte con tu correo electrónico"
    fill_in "Correo electrónico", with: 'alice@test.com'
    fill_in "Nueva contraseña", with: 'alice123'
    fill_in "Confirma tu nueva contraseña", with: 'alice123'
    click_on "Registrarte"

    assert_current_path(root_path)
    assert_text "Student"
    assert_text "alice@test.com"
  end

  test "user can't sign up due to incorrect confirmation password" do
    visit new_account_path

    assert_text "Registrarte con tu correo electrónico"
    fill_in "Correo electrónico", with: 'alice@test.com'
    fill_in "Nueva contraseña", with: 'alice123'
    fill_in "Confirma tu nueva contraseña", with: 'alice321'
    click_on "Registrarte"

    assert_text "Ocurrió un error al registrarte"
  end

  test "user can't sign up due to email already in use" do
    visit new_account_path
    create_user

    assert_text "Registrarte con tu correo electrónico"
    fill_in "Correo electrónico", with: 'bob@test.com'
    fill_in "Nueva contraseña", with: 'bob321'
    fill_in "Confirma tu nueva contraseña", with: 'bob321'
    click_on "Registrarte"

    assert_text "Ocurrió un error al registrarte"
  end
end
