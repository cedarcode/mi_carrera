require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  setup do
  end

  test "user creates new account" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_text "Google"
  end

  test "user signs in with google" do
    visit new_account_path
    # click_on "Sign in with Google"
  end
end
