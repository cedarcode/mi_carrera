require "application_system_test_case"

class CompoundPrerequisitesTest < ApplicationSystemTestCase
  setup do
    maths = SubjectGroup.create!(code: "1111", name: "Matemáticas")
    prog = SubjectGroup.create!(code: "2222", name: "Programación")
    @gal1 = Subject.create!(code: "gal1", name: "GAL 1", credits: 8, group_id: maths.id)
    @gal2 = Subject.create!(code: "gal2", name: "GAL 2", credits: 8, group_id: maths.id)
    @p1 = Subject.create!(code: "p1", name: "P1", credits: 5, group_id: prog.id)
    p2 = Subject.create!(code: "p2", name: "P2", credits: 9, group_id: prog.id)

    @gal1.create_course!
    @gal1.create_exam!

    @gal2.create_course!
    @gal2.create_exam!

    @p1.create_course!
    @p1.create_exam!

    p2.create_course!
    p2.create_exam!

    SubjectPrerequisite.create!(approvable_id: @gal1.exam.id, approvable_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(approvable_id: @gal2.exam.id, approvable_needed_id: @gal2.course.id)
    SubjectPrerequisite.create!(approvable_id: @p1.exam.id, approvable_needed_id: @p1.course.id)
    or_prerequisite = LogicalPrerequisite.create!(approvable_id: p2.course.id, logical_operator: "or")
    CreditsPrerequisite.create!(parent_prerequisite_id: or_prerequisite.id, subject_group_id: nil, credits_needed: 15)
    and_prerequisite = LogicalPrerequisite.create!(parent_prerequisite_id: or_prerequisite.id, logical_operator: "and")
    SubjectPrerequisite.create!(parent_prerequisite_id: and_prerequisite.id, approvable_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(parent_prerequisite_id: and_prerequisite.id, approvable_needed_id: @gal2.course.id)
    SubjectPrerequisite.create!(parent_prerequisite_id: and_prerequisite.id, approvable_needed_id: @p1.course.id)
    and_prerequisite = LogicalPrerequisite.create!(parent_prerequisite_id: or_prerequisite.id, logical_operator: "and")
    CreditsPrerequisite.create!(parent_prerequisite_id: and_prerequisite.id,
                                subject_group_id: maths.id,
                                credits_needed: 5)

    CreditsPrerequisite.create!(parent_prerequisite_id: and_prerequisite.id,
                                subject_group_id: prog.id,
                                credits_needed: 5)
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "P2"
  end

  test "student cant see subjects even with subjects approved" do
    visit root_path

    assert_no_text "P2"
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_async_request
    assert_no_text "P2"
  end

  test "student can see subjects if they meet the requirements of the first operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal2.id}_exam_approved", visible: :all

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the second operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@p1.id}_course_approved", visible: :all

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the third operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@p1.id}_course_approved", visible: :all
    wait_for_async_request
    check "checkbox_#{@p1.id}_exam_approved", visible: :all

    assert_text "P2"
  end
end
