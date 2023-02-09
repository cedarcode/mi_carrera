require "application_system_test_case"

class CompoundPrerequisitesTest < ApplicationSystemTestCase
  setup do
    maths = create :subject_group
    prog = create :subject_group
    @gal1 = create :subject, :with_exam, name: "GAL 1", credits: 8, group: maths
    @gal2 = create :subject, :with_exam, name: "GAL 2", credits: 8, group: maths
    @p1 = create :subject, :with_exam, name: "P1", credits: 5, group: prog
    p2 = create :subject, :with_exam, name: "P2", credits: 9, group: prog

    create :subject_prerequisite, approvable: @gal1.exam, approvable_needed: @gal1.course
    create :subject_prerequisite, approvable: @gal2.exam, approvable_needed: @gal2.course
    create :subject_prerequisite, approvable: @p1.exam, approvable_needed: @p1.course

    create :or_prerequisite, approvable: p2.course, operands_prerequisites: [
      create(:credits_prerequisite, credits_needed: 15),

      create(:and_prerequisite, operands_prerequisites: [
        create(:subject_prerequisite, approvable_needed: @gal1.course),
        create(:subject_prerequisite, approvable_needed: @gal2.course),
        create(:subject_prerequisite, approvable_needed: @p1.course)
      ]),

      create(:and_prerequisite, operands_prerequisites: [
        create(:credits_prerequisite, subject_group: maths, credits_needed: 5),
        create(:credits_prerequisite, subject_group: prog, credits_needed: 5)
      ])
    ]
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "P2"
  end

  test "student cant see subjects even with subjects approved" do
    visit root_path

    assert_no_text "P2"
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_approvables_reloaded
    assert_no_text "P2"
  end

  test "student can see subjects if they meet the requirements of the first operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal2.id}_exam_approved", visible: :all

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the second operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@p1.id}_course_approved", visible: :all

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the third operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@p1.id}_course_approved", visible: :all
    wait_for_approvables_reloaded
    check "checkbox_#{@p1.id}_exam_approved", visible: :all

    assert_text "P2"
  end
end
