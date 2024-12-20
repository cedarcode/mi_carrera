require 'rails_helper'

RSpec.describe "PlannedSubjects", type: :system do
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

    sign_in user

    visit planned_subjects_path

    within "#planned_subjects" do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_text "T1"
    end

    expect(page).to have_text "Current credits: 11"
    expect(page).to have_text "Total planned credits: 11"

    within "#not_planned_subjects" do
      expect(page).to have_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    within ".mdc-deprecated-list-item", text: "GAL 1" do
      find("span", text: "add_circle_outline").click
    end

    within "#planned_subjects" do
      expect(page).to have_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_text "T1"
    end

    within "#not_planned_subjects" do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    expect(page).to have_text "Current credits: 11"
    expect(page).to have_text "Total planned credits: 20"

    within ".mdc-deprecated-list-item", text: "GAL 1" do
      find("span", text: "remove_circle_outline").click
    end

    within "#planned_subjects" do
      expect(page).to have_no_text "GAL 1"
      expect(page).to have_no_text "GAL 2"
      expect(page).to have_text "T1"
    end

    within "#not_planned_subjects" do
      expect(page).to have_text "GAL 1"
      expect(page).to have_text "GAL 2"
      expect(page).to have_no_text "T1"
    end

    expect(page).to have_text "Current credits: 11"
    expect(page).to have_text "Total planned credits: 11"
  end
end
