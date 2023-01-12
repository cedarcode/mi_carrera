require "application_system_test_case"

class EditProfileTest < ApplicationSystemTestCase
  setup do
    visit root_path
    @user = create_user(email: "alice@test.com", password: "alice123")
    @user2 = create_user(email: "alice2@test.com", password: "alice123")
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: @user.password
    click_on "Ingresar"
  end

  test "user can edit profile" do
    click_actions_menu
    click_on "Editar Perfil"

    # fail case - current password is wrong
    fill_in "Contraseña actual", with: "wrong"
    click_on "Guardar"
    within('.form-input-container', text: 'Contraseña actual') do
      assert_text "No es válido"
    end

    # fail case - new password is too short
    fill_in "Contraseña actual", with: @user.password
    fill_in "Nueva contraseña", with: "123"
    fill_in "Confirma tu nueva contraseña", with: "123"
    click_on "Guardar"
    within('.form-input-container', text: 'Nueva contraseña') do
      assert_text "Es demasiado corto (6 caracteres mínimo)"
    end

    # fail case - new password and confirmation don't match
    fill_in "Nueva contraseña", with: "alice123"
    fill_in "Confirma tu nueva contraseña", with: "alice1234"
    fill_in "Contraseña actual", with: @user.password
    click_on "Guardar"
    within('.form-input-container', text: 'Confirma tu nueva contraseña') do
      assert_text "No coincide"
    end

    # fail case - email is already taken
    fill_in 'Correo electrónico', with: @user2.email
    fill_in 'Contraseña actual', with: @user.password
    click_on 'Guardar'
    within('.form-input-container', text: 'Correo electrónico') do
      assert_text "Ya está en uso"
    end

    # success case
    fill_in "Nueva contraseña", with: "alice1234"
    fill_in "Confirma tu nueva contraseña", with: "alice1234"
    fill_in "Contraseña actual", with: @user.password
    fill_in "Correo electrónico", with: 'newemail@gmail.com'
    click_on "Guardar"
    assert_text "Actualizaste tu cuenta correctamente."

    click_actions_menu

    within_actions_menu do
      assert_text "newemail@gmail.com"
    end
  end
end
