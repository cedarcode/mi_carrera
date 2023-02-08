require "application_system_test_case"

class AutoUnapprovalTest < ApplicationSystemTestCase
  setup do
    @subject1 = create :subject, name: "Subject 1", credits: 1
    @subject2 = create :subject, name: "Subject 2", credits: 2
    @subject3 = create :subject, name: "Subject 3", credits: 3

    create :subject_prerequisite, approvable: @subject3.course, approvable_needed: @subject2.course
    create :subject_prerequisite, approvable: @subject2.course, approvable_needed: @subject1.course
  end

  test "unapproving Subject 1 unapproves the rest" do
    visit root_path
    find("#checkbox_#{@subject1.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded
    find("#checkbox_#{@subject2.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded
    find("#checkbox_#{@subject3.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded

    visit root_path
    find("#checkbox_#{@subject1.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded
    visit root_path

    assert_text "0 créditos"
    assert_no_text "Subject 2"
    assert_no_text "Subject 3"
    assert page.has_unchecked_field?("checkbox_#{@subject1.id}_course_approved", visible: :all)
  end
end
