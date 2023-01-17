require "application_system_test_case"

class DependenciesTest < ApplicationSystemTestCase
  setup do
    @gal1 = create_subject(name: "GAL 1", credits: 9, exam: true)
    gal2 = create_subject(name: "GAL 2", credits: 9, exam: true)

    SubjectPrerequisite.create!(approvable_id: gal2.course.id, approvable_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(approvable_id: @gal1.exam.id, approvable_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(approvable_id: gal2.exam.id, approvable_needed_id: gal2.course.id)

    @subject1 = create_subject(name: "Subject 1", credits: 1, exam: false)
    @subject2 = create_subject(name: "Subject 2", credits: 2, exam: true)
    @subject3 = create_subject(name: "Subject 3", credits: 3, exam: false)

    SubjectPrerequisite.create!(approvable_id: @subject2.course.id, approvable_needed_id: @subject1.course.id)
    SubjectPrerequisite.create!(approvable_id: @subject3.course.id, approvable_needed_id: @subject2.exam.id)
  end

  test "student sees exam disabled" do
    visit subject_path(@gal1)

    assert_unchecked_field("Examen aprobado?", disabled: true, visible: :all)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: :all)
  end

  test "student can enable exams from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: :all

    assert_unchecked_field("Examen aprobado?", disabled: false, visible: :all)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: false, visible: :all)
  end

  test "student can enable exams from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click

    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: false, visible: :all)
    visit subject_path(@gal1)
    assert_unchecked_field("Examen aprobado?", disabled: false, visible: :all)
  end

  test "student can disable exams from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: :all
    wait_for_async_request

    uncheck "Curso aprobado?", visible: :all

    assert_unchecked_field("Examen aprobado?", disabled: true, visible: :all)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: :all)
  end

  test "student can disable exams from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click
    wait_for_async_request

    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click

    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: :all)
    visit subject_path(@gal1)
    assert_unchecked_field("Examen aprobado?", disabled: true, visible: :all)
  end

  test "student cant see hidden subjects" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can reaveal hidden subjects from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: :all
    wait_for_async_request

    visit root_path
    assert_text "GAL 2"
  end

  test "student can reaveal hidden subjects from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click

    assert_text "GAL 2"
  end

  test "student can hide subjects from show" do
    visit subject_path(@gal1)
    check "Curso aprobado?", visible: :all
    wait_for_async_request

    visit subject_path(@gal1)
    uncheck "Curso aprobado?", visible: :all
    wait_for_async_request

    visit root_path
    assert_no_text "GAL 2"
  end

  test "student can hide subjects from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click
    wait_for_async_request

    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click

    assert_no_text "GAL 2"
  end

  test 'student can navigate subjects throught their prerequisites' do
    visit all_subjects_path
    # go to subject 3, assert that subject 2 exam is required and go to subject 2 through the link
    click_on @subject3.name
    assert_text @subject3.name
    click_on @subject2.name + ' (examen)'

    # assert that subject 1 course is required and go to subject 1 through the link
    assert_text @subject2.name
    click_on @subject1.name + ' (curso)'
    assert_text @subject1.name
  end
end
