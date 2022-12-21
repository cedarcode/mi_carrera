require "application_system_test_case"

class EditProfileTest < ApplicationSystemTestCase
  setup do
    visit root_path
    @user = create_user(email: "alice@test.com", full_name: "Alice A", password: "alice123")
    @user2 = create_user(email: "alice2@test.com", full_name: "Alice 2", password: "alice123")
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: @user.password
    click_on "Ingresar"
  end

  test "user can edit profile" do
    find(".google-sign-in-image").click
    click_on "Editar Perfil"

    # fail case - current password is wrong
    fill_in "Nombre completo", with: "Alice B"
    fill_in "Contraseña actual", with: "wrong"
    click_on "Guardar"
    within('.sign-in-option', text: 'Contraseña actual') do
      assert_text "No es válido"
    end

    # fail case - new password is too short
    fill_in "Contraseña actual", with: @user.password
    fill_in "Nueva contraseña", with: "123"
    fill_in "Confirma tu nueva contraseña", with: "123"
    click_on "Guardar"
    within('.sign-in-option', text: 'Nueva contraseña') do
      assert_text "Es demasiado corto (6 caracteres mínimo)"
    end

    # fail case - new password and confirmation don't match
    fill_in "Nueva contraseña", with: "alice123"
    fill_in "Confirma tu nueva contraseña", with: "alice1234"
    fill_in "Contraseña actual", with: @user.password
    click_on "Guardar"
    within('.sign-in-option', text: 'Confirma tu nueva contraseña') do
      assert_text "No coincide"
    end

    # fail case - email is already taken
    fill_in 'Correo electrónico', with: @user2.email
    fill_in 'Contraseña actual', with: @user.password
    click_on 'Guardar'
    within('.sign-in-option', text: 'Correo electrónico') do
      assert_text "Ya está en uso"
    end

    # success case
    fill_in "Nueva contraseña", with: "alice1234"
    fill_in "Confirma tu nueva contraseña", with: "alice1234"
    fill_in "Contraseña actual", with: @user.password
    fill_in "Nombre completo", with: "Alice B"
    fill_in "Correo electrónico", with: 'newemail@gmail.com'
    click_on "Guardar"
    assert_text "Actualizaste tu cuenta correctamente."
    assert_text "Alice B"
  end
end
