require "application_system_test_case"

class ApprovalTest < ApplicationSystemTestCase
  setup do
    @subject = Subject.create!(name: "GAL 1", credits: 9)
  end

  test "student adds approved course" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: false
    click_on "arrow_back"

    assert_text "0 créditos"
    assert page.has_unchecked_field?("checkbox_#{@subject.id}", visible: false)

    click_on "GAL 1"

    assert page.has_checked_field?("Curso aprobado?", visible: false)
  end

  test "student adds approved exam" do
    visit subject_path(@subject)

    check "Examen aprobado?", visible: false
    click_on "arrow_back"

    assert_text "9 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}", visible: false)

    click_on "GAL 1"

    assert page.has_checked_field?("Examen aprobado?", visible: false)
  end

  test "student adds approved subject" do
    visit root_path

    find(".mdc-checkbox").click

    assert_text "9 créditos"

    visit root_path

    assert_text "9 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}", visible: false)
  end
end
