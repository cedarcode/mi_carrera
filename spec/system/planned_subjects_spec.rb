require 'rails_helper'
require 'support/planned_subjects_helper'

RSpec.describe "PlannedSubjects", type: :system do
  include PlannedSubjectsHelper

  let(:user) { create(:user, planned_semesters: 5) }

  before do
    gal1 = create(:subject, :with_exam, name: "GAL 1", credits: 9, code: "1030")
    gal2 = create(:subject, :with_exam, name: "GAL 2", credits: 10, code: "1031")
    taller = create(:subject, name: "Taller 1", short_name: 'T1', credits: 11)
    user.approvals << taller.course.id

    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])

    sign_in user
  end

  it "can add and remove subjects to planner" do
    visit subject_plans_path

    assert_banner_present('Bienvenido a tu planificador de materias: arrastra, suelta y organiza tu semestre')
    click_button 'Listo'
    assert_banner_dismissed

    expect(page).to have_text "Planificador"
    expect(page).to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 0"
    assert_no_subject "GAL 1"
    assert_no_subject "GAL 2"

    within_not_planned_approved_subjects do
      assert_no_subject "GAL 1"
      assert_no_subject "GAL 2"
      assert_approved_subject "T1"

      move_subject_to_semester "T1", "Semestre 1"
    end

    expect(page).not_to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 11"

    within_semester_section("Semestre 1") do
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      assert_no_subject "GAL 1"
      assert_no_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 11"
      assert_subject_selector_contains "GAL 1"
      assert_subject_selector_contains "GAL 2"
      assert_subject_not_in_selector "T1"
    end

    within_subject_row("T1") do
      click_on "remove_circle_outline"
    end

    expect(page).to have_text "Créditos planeados: 0"

    within_semester_section("Semestre 1") do
      expect(page).to have_text "Créditos planeados: 0"
    end

    within_not_planned_approved_subjects do
      assert_approved_subject "T1"

      move_subject_to_semester "T1", "Semestre 1"
    end

    expect(page).to have_text "Créditos planeados: 11"

    within_semester_section("Semestre 1") do
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      expect(page).to have_text "Créditos planeados: 11"
    end

    within_semester_section("Semestre 1") do
      within_add_subject_section do
        select_from_choices('1030 - GAL 1')
        find("button[type='submit']").click
      end

      assert_available_subject "GAL 1"
      assert_planned_subject "GAL 1"
      assert_planned_subject "T1"
      assert_no_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 20"
      assert_subject_not_in_selector "T1"
      assert_subject_not_in_selector "GAL 1"
      assert_subject_selector_contains "GAL 2"
    end

    expect(page).to have_text "Créditos planeados: 20"

    within_each_semester_section(user.planned_semesters) do
      assert_subject_not_in_selector "1030 - GAL 1"
    end

    within_semester_section("Semestre 2") do
      within_add_subject_section do
        select_from_choices('1031 - GAL 2')
        find("button[type='submit']").click
      end

      assert_blocked_subject "GAL 2"
      assert_planned_subject "GAL 2"
      assert_no_subject "GAL 1"
      assert_no_subject "T1"
      expect(page).to have_text "Créditos planeados: 10"
      assert_subject_not_in_selector "GAL 2"
      assert_subject_not_in_selector "GAL 1"
      assert_subject_not_in_selector "T1"
    end

    expect(page).to have_text "Créditos planeados: 30"

    within_each_semester_section(user.planned_semesters) do
      assert_subject_not_in_selector "1031 - GAL 2"
    end

    within_semester_section("Semestre 2") do
      move_subject_to_semester "GAL 2", "Semestre 3"

      expect(page).to have_text "No hay materias planificadas para este semestre"
      assert_no_subject "GAL 1"
      assert_no_subject "GAL 2"
      assert_no_subject "T1"
      expect(page).to have_text "Créditos planeados: 0"
      assert_subject_not_in_selector "GAL 2"
      assert_subject_not_in_selector "GAL 1"
      assert_subject_not_in_selector "T1"
    end

    within_semester_section("Semestre 3") do
      assert_blocked_subject "GAL 2"
      assert_planned_subject "GAL 2"
      assert_no_subject "GAL 1"
      assert_no_subject "T1"
      expect(page).to have_text "Créditos planeados: 10"
      assert_subject_not_in_selector "GAL 2"
      assert_subject_not_in_selector "GAL 1"
      assert_subject_not_in_selector "T1"
    end

    expect(page).to have_text "Créditos planeados: 30"

    within_semester_section("Semestre 3") do
      within_subject_row("GAL 2") do
        find("button[type='submit']").click
      end

      assert_no_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 0"
      assert_subject_selector_contains "GAL 2"
    end

    expect(page).to have_text "Créditos planeados: 20"

    within_each_semester_section(user.planned_semesters) do
      assert_subject_selector_contains "1031 - GAL 2"
    end

    within_semester_section("Semestre 1") do
      within_subject_row("T1") do
        find("button[type='submit']").click
      end

      assert_no_subject "T1"
      expect(page).to have_text "Créditos planeados: 9"
    end

    expect(page).to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 9"

    click_button "Agregar semestre"

    expect(page).to have_text "Semestre 6"

    within_not_planned_approved_subjects do
      move_subject_to_semester "T1", "Semestre 6"
    end

    within_semester_section("Semestre 6") do
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      expect(page).to have_text "Créditos planeados: 11"

      within_add_subject_section do
        select_from_choices('1031 - GAL 2')
        find("button[type='submit']").click
      end

      assert_blocked_subject "GAL 2"
      assert_planned_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 21"
    end

    expect(page).to have_text "Créditos planeados: 30"
  end
end
