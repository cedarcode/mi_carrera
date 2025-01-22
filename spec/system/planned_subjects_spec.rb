require 'rails_helper'
require 'support/planned_subjects_test_helper'

RSpec.describe "PlannedSubjects", type: :system do
  include PlannedSubjectsTestHelper

  it "can add and remove subjects to planner" do
    gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, code: "1030"
    create :subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course

    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 10
    create :and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ]

    taller = create :subject, name: "Taller 1", short_name: 'T1', credits: 11

    user = create(:user, approvals: [taller.course.id])

    ENV['ENABLE_PLANNER'] = 'true'

    sign_in user

    visit planned_subjects_path

    expect(page).to have_text "Materias planeadas"
    expect(page).to have_text "Materias recomendadas"

    within_planned_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      assert_approved_subject "T1"
    end

    expect(page).to have_text "Créditos actuales: 11"
    expect(page).to have_text "Créditos planeados: 11"

    within_not_planned_subjects do
      expect(page).to have_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    within ".mdc-deprecated-list-item", text: "GAL 1" do
      find("span", text: "add_circle_outline").click
    end

    within_planned_subjects do
      assert_available_subject "GAL 1"
      expect(page).to have_no_text "GAL 2"
      assert_approved_subject "T1"
    end

    within_not_planned_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    expect(page).to have_text "Créditos actuales: 11"
    expect(page).to have_text "Créditos planeados: 20"

    within ".mdc-deprecated-list-item", text: "GAL 2" do
      find("span", text: "add_circle_outline").click
    end

    within_planned_subjects do
      assert_available_subject "GAL 1"
      assert_blocked_subject "GAL 2"
      assert_approved_subject "T1"
    end

    expect(page).to have_text "Créditos actuales: 11"
    expect(page).to have_text "Créditos planeados: 30"

    within ".mdc-deprecated-list-item", text: "GAL 2" do
      find("span", text: "remove_circle_outline").click
    end

    within_planned_subjects do
      assert_available_subject "GAL 1"
      expect(page).to have_no_text "GAL 2"
      assert_approved_subject "T1"
    end

    within_not_planned_subjects do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    expect(page).to have_text "Créditos actuales: 11"
    expect(page).to have_text "Créditos planeados: 20"
  end
end
