require "application_system_test_case"

class CreditsAsPrerequisitesTest < ApplicationSystemTestCase
  setup do
    total = SubjectsGroup.create!(name: "Carrera de Ingeniería en Computación")
    maths = SubjectsGroup.create!(name: "Matemáticas")
    @gal1 = Subject.create!(name: "GAL 1", credits: 9, group_id: maths.id)
    @gal2 = Subject.create!(name: "GAL 2", credits: 9, group_id: maths.id)
    gal3 = Subject.create!(name: "GAL 3", credits: 9, group_id: maths.id)
    @gal1.create_course!
    @gal1.create_exam!
    @gal2.create_course!
    @gal2.create_exam!
    gal3.create_course!
    gal3.create_exam!
    CreditsPrerequisite.create!(dependency_item_id: @gal2.course.id, subjects_group_id: total.id, credits_needed: 5)
    CreditsPrerequisite.create!(dependency_item_id: gal3.course.id, subjects_group_id: maths.id, credits_needed: 10)
    Dependency.create!(prerequisite_id: @gal1.course.id, dependency_item_id: @gal1.exam.id)
    Dependency.create!(prerequisite_id: @gal2.course.id, dependency_item_id: @gal2.exam.id)
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
