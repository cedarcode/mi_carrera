require "application_system_test_case"

class SubjectsTest < ApplicationSystemTestCase
  test "can search for subjects" do
    gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, code: "1030"
    create :subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course

    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 10
    create :and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ]

    create :subject, name: "Taller", credits: 11

    visit all_subjects_path

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_text "Taller"

    fill_in 'search', with: "Taller\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "Taller"

    fill_in 'search', with: "This subject does not exist\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_no_text "Taller"

    fill_in 'search', with: " \n"

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_text "Taller"
  end
end
