require "application_system_test_case"

class DependenciesTest < ApplicationSystemTestCase
  setup do
    @gal1 = Subject.create!(name: "GAL 1", credits: 9)
    gal2 = Subject.create!(name: "GAL 2", credits: 9)
    @gal1.create_course!
    @gal1.create_exam!
    gal2.create_course!
    gal2.create_exam!
    Dependency.create!(prerequisite_id: @gal1.course.id, dependency_item_id: @gal1.exam.id)
    Dependency.create!(prerequisite_id: gal2.course.id, dependency_item_id: gal2.exam.id)
    Dependency.create!(prerequisite_id: @gal1.course.id, dependency_item_id: gal2.course.id)
  end

  test "student sees exam disabled" do
    visit subject_path(@gal1)

    assert_unchecked_field("Examen aprobado?", disabled: true, visible: false)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: false)
  end

  test "student can enable exams from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: false

    assert_unchecked_field("Examen aprobado?", disabled: false, visible: false)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: false, visible: false)
  end

  test "student can enable exams from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click

    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: false, visible: false)
    visit subject_path(@gal1)
    assert_unchecked_field("Examen aprobado?", disabled: false, visible: false)
  end

  test "student can disable exams from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: false
    wait_for_async_request

    uncheck "Curso aprobado?", visible: false

    assert_unchecked_field("Examen aprobado?", disabled: true, visible: false)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: false)
  end

  test "student can disable exams from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click
    wait_for_async_request

    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click

    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: false)
    visit subject_path(@gal1)
    assert_unchecked_field("Examen aprobado?", disabled: true, visible: false)
  end

  test "student cant see hidden subjects" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can reaveal hidden subjects from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: false
    wait_for_async_request

    visit root_path
    assert_text "GAL 2"
  end

  test "student can reaveal hidden subjects from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click

    assert_text "GAL 2"
  end

  test "student can hide subjects from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: false
    wait_for_async_request

    visit subject_path(@gal1)
    uncheck "Curso aprobado?", visible: false
    wait_for_async_request

    visit root_path
    assert_no_text "GAL 2"
  end

  test "student can hide subjects from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click
    wait_for_async_request

    find("#checkbox_#{@gal1.id}_course_approved", visible: false).click

    assert_no_text "GAL 2"
  end
end
