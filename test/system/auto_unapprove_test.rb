require "application_system_test_case"

class AutoUnapprovalTest < ApplicationSystemTestCase
  setup do
    @subject1 = create_subject("Subject 1", credits: 1, exam: false)
    @subject2 = create_subject("Subject 2", credits: 2, exam: false)
    @subject3 = create_subject("Subject 3", credits: 3, exam: false)

    SubjectPrerequisite.create!(approvable_id: @subject3.course.id, approvable_needed_id: @subject2.course.id)
    SubjectPrerequisite.create!(approvable_id: @subject2.course.id, approvable_needed_id: @subject1.course.id)
  end

  test "unapproving Subject 1 unapproves the rest" do
    visit root_path
    find("#checkbox_#{@subject1.id}_course_approved", visible: false).click
    wait_for_async_request
    find("#checkbox_#{@subject2.id}_course_approved", visible: false).click
    wait_for_async_request
    find("#checkbox_#{@subject3.id}_course_approved", visible: false).click
    wait_for_async_request

    visit root_path
    find("#checkbox_#{@subject1.id}_course_approved", visible: false).click
    wait_for_async_request
    visit root_path

    assert_text "0 créditos"
    assert_no_text "Subject 2"
    assert_no_text "Subject 3"
    assert page.has_unchecked_field?("checkbox_#{@subject1.id}_course_approved", visible: false)
  end
end
