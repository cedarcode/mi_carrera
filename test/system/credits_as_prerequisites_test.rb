require "application_system_test_case"

class CreditsAsPrerequisitesTest < ApplicationSystemTestCase
  setup do
    maths = create :subject_group
    @gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, group: maths
    @gal2 = create :subject, :with_exam, name: "GAL 2", credits: 9, group: maths
    gal3 = create :subject, :with_exam, name: "GAL 3", credits: 9, group: maths

    create :subject_prerequisite, approvable: @gal1.exam, approvable_needed: @gal1.course
    create :credits_prerequisite, approvable: @gal2.course, credits_needed: 5
    create :subject_prerequisite, approvable: @gal2.exam, approvable_needed: @gal2.course
    create :credits_prerequisite, approvable: gal3.course, subject_group: maths, credits_needed: 10
    create :subject_prerequisite, approvable: gal3.exam, approvable_needed: gal3.course
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "GAL 2"
  end

  test "student can see subjects with enough credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all

    assert_text "GAL 2"
  end

  test "student can hide subjects" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all

    assert_text "GAL 2"
    uncheck "checkbox_#{@gal1.id}_exam_approved", visible: :all
    assert_no_text "GAL 2"
  end

  test "student cant see subjects without enough group credits" do
    visit root_path

    assert_no_text "GAL 3"
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_approvables_reloaded

    assert_no_text "GAL 3"
  end

  test "student can see subjects with enough group credits" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal2.id}_exam_approved", visible: :all

    assert_text "GAL 3"
  end
end
