require "application_system_test_case"

class CreditsAsPrerequisitesTest < ApplicationSystemTestCase
  setup do
    visit visitor_home_index_path

    maths = create_group(name: "Matemáticas")
    @gal1 = create_subject(name: "GAL 1", credits: 9, group: maths)
    @gal2 = create_subject(name: "GAL 2", credits: 9, group: maths)
    gal3 = create_subject(name: "GAL 3", credits: 9, group: maths)

    SubjectPrerequisite.create!(approvable_id: @gal1.exam.id, approvable_needed_id: @gal1.course.id)
    CreditsPrerequisite.create!(approvable_id: @gal2.course.id, subject_group_id: nil, credits_needed: 5)
    SubjectPrerequisite.create!(approvable_id: @gal2.exam.id, approvable_needed_id: @gal2.course.id)
    CreditsPrerequisite.create!(approvable_id: gal3.course.id, subject_group_id: maths.id, credits_needed: 10)
    SubjectPrerequisite.create!(approvable_id: gal3.exam.id, approvable_needed_id: gal3.course.id)
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can see subjects with enough credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all

    assert_text "GAL 2"
  end

  test "student can hide subjects" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all

    assert_text "GAL 2"
    uncheck "checkbox_#{@gal1.id}_exam_approved", visible: :all
    assert_no_text "GAL 2"
  end

  test "student cant see subjects without enough group credits" do
    visit root_path

    assert_no_text "GAL 3"
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    assert_no_text "GAL 3"
  end

  test "student can see subjects with enough group credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal2.id}_exam_approved", visible: :all

    assert_text "GAL 3"
  end
end
