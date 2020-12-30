require "application_system_test_case"

class LoginLogoutTest < ApplicationSystemTestCase
  setup do
    @user = User.new(name: "Test User", email_address: "test.user@cedarcode.com")
  end

  test "logged in user can see link to log out" do
    visit root_path
    session[:user_id] = @user.id
    click_on "person"

    assert_selector "a", text: 'Cerrar sesión'
    click_on "Cerrar sesión"
    assert_equal nil, session[:user_id]
  end

  test "user can see log in icon and google log in button" do
    visit root_path
    click_on "person"
    click_on "login"

    assert_text "Iniciar sesión"
    assert_selector "button", text: 'Iniciar sesión con Google'
  end
end
