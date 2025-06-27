require 'rails_helper'
require 'support/planned_subjects_helper'

RSpec.describe "PlannedSubjects", type: :system do
  include PlannedSubjectsHelper

  before do
    gal1 = create(:subject, :with_exam, name: "GAL 1", credits: 9, code: "1030")
    gal2 = create(:subject, :with_exam, name: "GAL 2", credits: 10, code: "1031")
    taller = create(:subject, name: "Taller 1", short_name: 'T1', credits: 11)
    user = create(:user, approvals: [taller.course.id])

    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])

    sign_in user
  end

  around do |example|
    ENV['ENABLE_PLANNER'] = 'true'
    example.run
    ENV.delete('ENABLE_PLANNER')
  end

  it "can add and remove subjects to planner" do
    visit subject_plans_path

    expect(page).to have_text "Planificador"
    expect(page).to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 0"
    assert_no_subject "GAL 1"
    assert_no_subject "GAL 2"

    within_not_planned_approved_subjects do
      assert_no_subject "GAL 1"
      assert_no_subject "GAL 2"
      assert_approved_subject "T1"

      move_subject_to_semester "T1", "Primer semestre"
    end

    expect(page).not_to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 11"

    within_semester_section("Primer semestre") do
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      assert_no_subject "GAL 1"
      assert_no_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 11"
      assert_subject_selector_contains "GAL 1"
      assert_subject_selector_contains "GAL 2"
      assert_subject_not_in_selector "T1"
    end

    within_semester_section("Primer semestre") do
      within_add_subject_section do
        select_from_choices('GAL 1 - 1030')
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

    within_each_semester_section do
      assert_subject_not_in_selector "GAL 1 - 1030"
    end

    within_semester_section("Segundo semestre") do
      within_add_subject_section do
        select_from_choices('GAL 2 - 1031')
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

    within_each_semester_section do
      assert_subject_not_in_selector "GAL 2 - 1031"
    end

    within_semester_section("Segundo semestre") do
      within("form", text: "GAL 2") do
        find("button[type='submit']").click
      end

      assert_no_subject "GAL 2"
      expect(page).to have_text "Créditos planeados: 0"
      assert_subject_selector_contains "GAL 2"
    end

    expect(page).to have_text "Créditos planeados: 20"

    within_each_semester_section do
      assert_subject_selector_contains "GAL 2 - 1031"
    end

    within_semester_section("Primer semestre") do
      within("form", text: "T1") do
        find("button[type='submit']").click
      end

      assert_no_subject "T1"
      expect(page).to have_text "Créditos planeados: 9"
    end

    expect(page).to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Créditos planeados: 9"
  end
end
