require "application_system_test_case"

class DependenciesTest < ApplicationSystemTestCase
  setup do
    @gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9
    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 9

    create :subject_prerequisite, approvable: gal2.course, approvable_needed: @gal1.course
    create :subject_prerequisite, approvable: @gal1.exam, approvable_needed: @gal1.course
    create :subject_prerequisite, approvable: gal2.exam, approvable_needed: gal2.course

    @subject1 = create :subject, name: "Subject 1", credits: 1
    @subject2 = create :subject, :with_exam, name: "Subject 2", credits: 2
    @subject3 = create :subject, name: "Subject 3", credits: 3

    create :subject_prerequisite, approvable: @subject2.course, approvable_needed: @subject1.course
    create :subject_prerequisite, approvable: @subject3.course, approvable_needed: @subject2.exam
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
    wait_for_approvables_reloaded

    uncheck "Curso aprobado?", visible: :all

    assert_unchecked_field("Examen aprobado?", disabled: true, visible: :all)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@gal1.id}_exam_approved", disabled: true, visible: :all)
  end

  test "student can disable exams from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded

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
    wait_for_approvables_reloaded

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
    wait_for_approvables_reloaded

    visit subject_path(@gal1)
    uncheck "Curso aprobado?", visible: :all
    wait_for_approvables_reloaded

    visit root_path
    assert_no_text "GAL 2"
  end

  test "student can hide subjects from index" do
    visit root_path
    find("#checkbox_#{@gal1.id}_course_approved", visible: :all).click
    wait_for_approvables_reloaded

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
