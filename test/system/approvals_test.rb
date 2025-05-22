require "application_system_test_case"

class ApprovalsTest < ApplicationSystemTestCase
  test "can check and uncheck approvables from index and show page" do
    degree = create :degree, name: "Ing. comp", key: "computacion"
    ActsAsTenant.current_tenant = degree

    gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, code: "1030"
    create :subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course

    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 10
    create :and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ]

    taller = create :subject, name: "Taller", credits: 11

    visit root_path
    assert_text "Ing. comp"
    click_on 'Seleccionar'
    assert_current_path root_path

    assert_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "Taller"
    assert_text "0 créditos"

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)

    check_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)
    assert_text "0 créditos"

    uncheck_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)
    assert_text "0 créditos"

    check_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)
    assert_text "0 créditos"

    click_on "GAL 1"

    assert_text "Curso aprobado?"
    assert_text "Examen aprobado?"
    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)

    check_approvable(gal1.exam)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: true, disabled: false)

    uncheck_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)

    check_approvable(gal1.course)
    check_approvable(gal1.exam)

    visit root_path

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_text "Taller"
    assert_text "9 créditos"

    uncheck_approvable(gal1.course)

    assert_no_text "GAL 2"
    assert_text "0 créditos"

    check_approvable(taller.course)

    assert_text "11 créditos"

    visit all_subjects_path

    click_on "GAL 2"

    assert_approvable_checkbox(gal2.course, checked: false, disabled: true)
    assert_approvable_checkbox(gal2.exam, checked: false, disabled: false)

    find(".mdc-deprecated-list-item", text: "Todos los siguientes").click

    assert_text "1030 - GAL 1 (curso)"
    assert_text "1030 - GAL 1 (examen)"

    click_on "1030 - GAL 1 (examen)"

    assert_current_path subject_path(gal1)
  end
end
