require "application_system_test_case"

class CreateAccountTest < ApplicationSystemTestCase
  setup do
    @maths = create_group(name: "Matemáticas")
    @subject = create_subject(name: "GAL 1", credits: 9, group: @maths)
  end

  test "user creates account from index" do
    visit root_path
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_text "Google"
  end

  test "user creates account from subject show" do
    visit subject_path(@subject)
    assert_text "GAL 1"
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_text "Google"
  end

  test "user creates account from subject_groups show" do
    visit subject_group_path(@maths)
    assert_text "GAL 1"
    click_on "person"
    click_on "Crear cuenta"

    assert_text "Regístrate"
    assert_text "Google"
  end

  test "user signs in with google" do
    visit new_account_path
    assert_text "Regístrate"

    click_on "Registrarse con Google"
  end
end
