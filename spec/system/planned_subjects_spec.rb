require 'rails_helper'
require 'support/planned_subjects_helper'

RSpec.describe "PlannedSubjects", type: :system do
  include PlannedSubjectsHelper

  let(:semesters) do
    [
      "Primer semestre", "Segundo semestre", "Tercer semestre", "Cuarto semestre",
      "Quinto semestre", "Sexto semestre", "Séptimo semestre", "Octavo semestre",
      "Noveno semestre", "Décimo semestre"
    ]
  end
  let(:gal1) { create(:subject, :with_exam, name: "GAL 1", credits: 9, code: "1030") }
  let(:gal2) { create(:subject, :with_exam, name: "GAL 2", credits: 10, code: "1031") }
  let(:taller) { create(:subject, name: "Taller 1", short_name: 'T1', credits: 11) }
  let(:user) { create(:user, approvals: [taller.course.id]) }

  before do
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

    expect_initial_page_state

    add_approved_subject_to_first_semester
    add_available_subject_to_first_semester
    add_blocked_subject_to_second_semester
    remove_subject_from_second_semester
  end

  private

  def expect_initial_page_state
    expect(page).to have_text "Materias aprobadas sin planificar"
    expect(page).to have_text "Materias planificadas"
    expect(page).to have_text "Créditos planeados: 0"

    within_planned_subjects do
      semesters.each do |semester|
        within_semester_section(semester) do
          expect(page).to have_text "No hay materias planificadas para este semestre"
          expect(page).to have_no_selector("li", text: "GAL 1")
          expect(page).to have_no_selector("li", text: "GAL 2")
          expect(page).to have_no_selector("li", text: "T1")
          expect(page).to have_text "Créditos planeados: 0"
        end
      end
    end
  end

  def add_approved_subject_to_first_semester
    within_not_planned_approved_subjects do
      assert_subject_not_in_selector("GAL 1")
      assert_subject_not_in_selector("GAL 2")
      assert_not_planned_subject "T1"

      within("li", text: "T1") do
        find("button[type='submit']").click
      end
    end

    expect(page).not_to have_text "Materias aprobadas sin planificar"
    expect(page).to have_text "Créditos planeados: 11"

    within_planned_subjects do
      within_semester_section("Primer semestre") do
        assert_approved_subject "T1"
        assert_planned_subject "T1"
        expect(page).to have_no_selector("li", text: "GAL 1")
        expect(page).to have_no_selector("li", text: "GAL 2")
        expect(page).to have_text "Créditos planeados: 11"
        assert_subject_in_selector "GAL 1"
        assert_subject_in_selector "GAL 2"
        assert_subject_not_in_selector "T1"
      end
    end
  end

  def add_available_subject_to_first_semester
    within_planned_subjects do
      within_semester_section("Primer semestre") do
        within_subject_planning_form do
          select 'GAL 1 - 1030', from: "subject_plan_subject_id"
          find("button[type='submit']").click
        end

        assert_available_subject "GAL 1"
        assert_planned_subject "GAL 1"
        assert_planned_subject "T1"
        expect(page).to have_no_selector("li", text: "GAL 2")
        expect(page).to have_text "Créditos planeados: 20"
        assert_subject_not_in_selector "T1"
        assert_subject_not_in_selector "GAL 1"
        assert_subject_in_selector "GAL 2"
      end
    end

    expect(page).to have_text "Créditos planeados: 20"
  end

  def add_blocked_subject_to_second_semester
    within_planned_subjects do
      within_semester_section("Segundo semestre") do
        within_subject_planning_form do
          select 'GAL 2 - 1031', from: "subject_plan_subject_id"
          find("button[type='submit']").click
        end

        assert_blocked_subject "GAL 2"
        assert_planned_subject "GAL 2"
        expect(page).to have_no_selector("li", text: "GAL 1")
        expect(page).to have_no_selector("li", text: "T1")
        expect(page).to have_text "Créditos planeados: 10"
        assert_subject_not_in_selector "GAL 2"
        assert_subject_not_in_selector "GAL 1"
        assert_subject_not_in_selector "T1"
      end
    end

    expect(page).to have_text "Créditos planeados: 30"
  end

  def remove_subject_from_second_semester
    within_planned_subjects do
      within_semester_section("Segundo semestre") do
        within("li", text: "GAL 2") do
          find("button[type='submit']").click
        end

        expect(page).to have_no_selector("li", text: "GAL 2")
        expect(page).to have_text "Créditos planeados: 0"
        assert_subject_in_selector "GAL 2"
      end
    end

    expect(page).to have_text "Créditos planeados: 20"
  end
end
