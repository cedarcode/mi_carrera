require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  test "user can see a google sign in button" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Registro"
    assert_selector "button", text: 'Registrarte con Google'
  end

  test "user can sign up with email/password" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Registrarte con tu correo electrónico"
    assert_selector "button", text: 'Registrarte'
    fill_in "name", with: 'Test User'
    fill_in "email", with: 'test@test.com'
    fill_in "password", with: '123'
    fill_in "password_confirmation", with: '123'
    click_on "Registrarte"

    assert_text "Test User"
  end

  test "user can't sign up due to incorrect confirmation password" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Registrarte con tu correo electrónico"
    assert_selector "button", text: 'Registrarte'
    fill_in "name", with: 'Test User'
    fill_in "email", with: 'test@test.com'
    fill_in "password", with: '123'
    fill_in "password_confirmation", with: '321'
    click_on "Registrarte"

    assert_text "Ocurrió un error al crear el usuario"
  end
end
