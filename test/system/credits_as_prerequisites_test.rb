require "application_system_test_case"

class CreditsAsPrerequisitesTest < ApplicationSystemTestCase
  setup do
    @gal1 = Subject.create!(name: "GAL 1", credits: 9)
    gal2 = Subject.create!(name: "GAL 2", credits: 9)
    @gal1.create_course!
    @gal1.create_exam!
    gal2.create_course!(credits_needed: 5)
    gal2.create_exam!
    Dependency.create!(prerequisite_id: @gal1.course.id, dependency_item_id: @gal1.exam.id)
    Dependency.create!(prerequisite_id: gal2.course.id, dependency_item_id: gal2.exam.id)
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can see subjects with enough credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    visit root_path
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request

    visit root_path
    assert_text "GAL 2"
  end

  test "student can hide subjects" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    visit root_path
    check "checkbox_#{@gal1.id}_exam_approved", visible: false

    wait_for_async_request
    visit root_path
    assert_text "GAL 2"
    uncheck "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request
    visit root_path
    assert_no_text "GAL 2"
  end
end
