require "application_system_test_case"

class ApprovalTest < ApplicationSystemTestCase
  setup do
    @subject = create_subject("GAL 1", credits: 9, exam: true)
  end

  test "student adds approved course from show" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: false
    wait_for_async_request
    visit root_path

    assert_text "0 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}_course_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_checked_field?("Curso aprobado?", visible: false)
  end

  test "student adds approved course from index" do
    visit root_path

    find("#checkbox_#{@subject.id}_course_approved", visible: :all).click
    wait_for_async_request
    visit root_path

    assert_text "0 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}_course_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_checked_field?("Curso aprobado?", visible: false)
  end

  test "student adds approved exam from show" do
    visit subject_path(@subject)

    check "Examen aprobado?", visible: false
    wait_for_async_request
    visit root_path

    assert_text "9 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}_exam_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_checked_field?("Examen aprobado?", visible: false)
  end

  test "student adds approved exam from index" do
    visit root_path
    find("#checkbox_#{@subject.id}_course_approved", visible: :all).click
    wait_for_async_request

    find("#checkbox_#{@subject.id}_exam_approved", visible: :all).click

    assert_text "9 créditos"
    visit root_path
    assert_text "9 créditos"
    assert page.has_checked_field?("checkbox_#{@subject.id}_exam_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_checked_field?("Examen aprobado?", visible: false)
  end

  test "student remove approved course from show" do
    visit subject_path(@subject)
    check "Curso aprobado?", visible: false
    wait_for_async_request

    visit subject_path(@subject)
    uncheck "Curso aprobado?", visible: false
    wait_for_async_request
    visit subject_path(@subject)

    assert page.has_unchecked_field?("Curso aprobado?", visible: false)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@subject.id}_course_approved", visible: false)
  end

  test "student remove approved course from index" do
    visit root_path
    find("#checkbox_#{@subject.id}_course_approved", visible: :all).click
    wait_for_async_request

    visit root_path
    find("#checkbox_#{@subject.id}_course_approved", visible: :all).click
    wait_for_async_request
    visit root_path

    assert page.has_unchecked_field?("checkbox_#{@subject.id}_course_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_unchecked_field?("Curso aprobado?", visible: false)
  end

  test "student remove approved exam from show" do
    visit subject_path(@subject)
    check "Curso aprobado?", visible: false
    wait_for_async_request
    check "Examen aprobado?", visible: false
    wait_for_async_request

    visit subject_path(@subject)
    uncheck "Examen aprobado?", visible: false
    wait_for_async_request
    visit subject_path(@subject)

    assert page.has_unchecked_field?("Examen aprobado?", visible: false)
    visit root_path
    assert page.has_unchecked_field?("checkbox_#{@subject.id}_exam_approved", visible: false)
  end

  test "student remove approved exam from index" do
    visit root_path
    find("#checkbox_#{@subject.id}_course_approved", visible: :all).click
    wait_for_async_request
    find("#checkbox_#{@subject.id}_exam_approved", visible: :all).click
    wait_for_async_request

    visit root_path
    find("#checkbox_#{@subject.id}_exam_approved", visible: :all).click
    wait_for_async_request
    visit root_path

    assert_text "0 créditos"
    assert page.has_unchecked_field?("checkbox_#{@subject.id}_exam_approved", visible: false)
    visit subject_path(@subject)
    assert page.has_unchecked_field?("Examen aprobado?", visible: false)
  end
end
