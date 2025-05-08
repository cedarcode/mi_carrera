require 'rails_helper'
require 'support/planned_subjects_spec_helper'

RSpec.describe "PlannedSubjects", type: :system do
  include PlannedSubjectsSpecHelper

  it "can add and remove subjects to planner" do
    gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, code: "1030"
    create :subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course

    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 10, code: "1031"
    create :and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ]

    taller = create :subject, name: "Taller 1", short_name: 'T1', credits: 11

    user = create(:user, approvals: [taller.course.id])

    ENV['ENABLE_PLANNER'] = 'true'

    sign_in user

    visit subject_plans_path

    expect(page).to have_text "Materias planeadas"
    expect(page).to have_text "Materias aprobadas sin semestre asignado"
    expect(page).to have_text "Planificar materia:"

    within_planned_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    within_not_planned_approved_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      assert_not_planned_subject "T1"
    end

    expect(page).to have_text "Créditos planeados: 0"

    within_not_planned_subjects do
      assert_subject_in_selector('GAL 1 - 1030')
      assert_subject_in_selector('GAL 2 - 1031')
      assert_subject_not_in_selector('Taller 1')
    end

    within ".mdc-deprecated-list-item", text: "T1" do
      find("span", text: "add_circle_outline").click
    end

    within_planned_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_text "Primer semestre"
      expect(page).to have_text "Créditos planeados: 11"
      assert_approved_subject "T1"
      assert_planned_subject "T1"
    end

    expect(page).to have_no_text "Materias aprobadas sin semestre asignado"

    within_not_planned_subjects do
      assert_subject_in_selector('GAL 1 - 1030')
      assert_subject_in_selector('GAL 2 - 1031')
      assert_subject_not_in_selector('Taller 1')
    end

    expect(page).to have_text "Créditos planeados: 11"

    within_not_planned_subjects do
      select 'GAL 1 - 1030', from: "subject_plan_subject_id"
      find("span", text: "add_circle_outline").click
      select 'GAL 2 - 1031', from: "subject_plan_subject_id"
      select "Sem. 2", from: "subject_plan_semester"
      find("span", text: "add_circle_outline").click
    end

    within_planned_subjects do
      assert_available_subject "GAL 1"
      assert_planned_subject "GAL 1"
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      expect(page).to have_text "Primer semestre"
      expect(page).to have_text "Créditos planeados: 20"
      assert_blocked_subject "GAL 2"
      assert_planned_subject "GAL 2"
      expect(page).to have_text "Segundo semestre"
      expect(page).to have_text "Créditos planeados: 10"
    end

    expect(page).to have_text "Créditos planeados: 30"

    within ".mdc-deprecated-list-item", text: "GAL 2" do
      find("span", text: "remove_circle_outline").click
    end

    within_planned_subjects do
      assert_available_subject "GAL 1"
      assert_planned_subject "GAL 1"
      assert_approved_subject "T1"
      assert_planned_subject "T1"
      expect(page).to have_text "Primer semestre"
      expect(page).to have_text "Créditos planeados: 20"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_no_text "Segundo semestre"
      expect(page).to have_no_text "Créditos planeados: 10"
    end

    within_not_planned_subjects do
      assert_subject_in_selector('GAL 2 - 1031')
      assert_subject_not_in_selector('GAL 1 - 1030')
      assert_subject_not_in_selector('Taller 1')
    end

    expect(page).to have_text "Créditos planeados: 20"
  end
end
