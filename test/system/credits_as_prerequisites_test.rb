require "application_system_test_case"

class CreditsAsPrerequisitesTest < ApplicationSystemTestCase
  setup do
    maths = SubjectGroup.create!(name: "Matemáticas")
    @gal1 = Subject.create!(name: "GAL 1", credits: 9, group_id: maths.id)
    @gal2 = Subject.create!(name: "GAL 2", credits: 9, group_id: maths.id)
    gal3 = Subject.create!(name: "GAL 3", credits: 9, group_id: maths.id)

    @gal1.create_course!
    @gal1.create_exam!

    @gal2.create_course!
    @gal2.create_exam!

    gal3.create_course!
    gal3.create_exam!

    SubjectPrerequisite.create!(dependency_item_id: @gal1.exam.id, dependency_item_needed_id: @gal1.course.id)
    CreditsPrerequisite.create!(dependency_item_id: @gal2.course.id, subject_group_id: nil, credits_needed: 5)
    SubjectPrerequisite.create!(dependency_item_id: @gal2.exam.id, dependency_item_needed_id: @gal2.course.id)
    CreditsPrerequisite.create!(dependency_item_id: gal3.course.id, subject_group_id: maths.id, credits_needed: 10)
    SubjectPrerequisite.create!(dependency_item_id: gal3.exam.id, dependency_item_needed_id: gal3.course.id)
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can see subjects with enough credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false

    assert_text "GAL 2"
  end

  test "student can hide subjects" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false

    assert_text "GAL 2"
    uncheck "checkbox_#{@gal1.id}_exam_approved", visible: false
    assert_no_text "GAL 2"
  end

  test "student cant see subjects without enough group credits" do
    visit root_path

    assert_no_text "GAL 3"
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    assert_no_text "GAL 3"
  end

  test "student can see subjects with enough group credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal2.id}_exam_approved", visible: false

    assert_text "GAL 3"
  end
end
