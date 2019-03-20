require "application_system_test_case"

class CompoundPrerequisitesTest < ApplicationSystemTestCase
  setup do
    maths = SubjectGroup.create!(name: "Matemáticas")
    prog = SubjectGroup.create!(name: "Programación")
    @gal1 = Subject.create!(name: "GAL 1", credits: 8, group_id: maths.id)
    @gal2 = Subject.create!(name: "GAL 2", credits: 8, group_id: maths.id)
    @p1 = Subject.create!(name: "P1", credits: 5, group_id: prog.id)
    p2 = Subject.create!(name: "P2", credits: 9, group_id: prog.id)

    @gal1.create_course!
    @gal1.create_exam!

    @gal2.create_course!
    @gal2.create_exam!

    @p1.create_course!
    @p1.create_exam!

    p2.create_course!
    p2.create_exam!

    SubjectPrerequisite.create!(dependency_item_id: @gal1.exam.id, dependency_item_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(dependency_item_id: @gal2.exam.id, dependency_item_needed_id: @gal2.course.id)
    SubjectPrerequisite.create!(dependency_item_id: @p1.exam.id, dependency_item_needed_id: @p1.course.id)
    or_prerequisite = LogicPrerequisite.create!(dependency_item_id: p2.course.id, logic_operator: "or")
    CreditsPrerequisite.create!(prerequisite_id: or_prerequisite.id, subject_group_id: nil, credits_needed: 15)
    and_prerequisite = LogicPrerequisite.create!(prerequisite_id: or_prerequisite.id, logic_operator: "and")
    SubjectPrerequisite.create!(prerequisite_id: and_prerequisite.id, dependency_item_needed_id: @gal1.course.id)
    SubjectPrerequisite.create!(prerequisite_id: and_prerequisite.id, dependency_item_needed_id: @gal2.course.id)
    SubjectPrerequisite.create!(prerequisite_id: and_prerequisite.id, dependency_item_needed_id: @p1.course.id)
    and_prerequisite = LogicPrerequisite.create!(prerequisite_id: or_prerequisite.id, logic_operator: "and")
    CreditsPrerequisite.create!(prerequisite_id: and_prerequisite.id, subject_group_id: maths.id, credits_needed: 5)
    CreditsPrerequisite.create!(prerequisite_id: and_prerequisite.id, subject_group_id: prog.id, credits_needed: 5)
  end

  test "student cant see subjects without enough credits" do
    visit root_path

    assert_no_text "P2"
  end

  test "student cant see subjects even with subjects approved" do
    visit root_path

    assert_no_text "P2"
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request
    assert_no_text "P2"
  end

  test "student can see subjects if they meet the requirements of the first operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal2.id}_exam_approved", visible: false

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the second operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal2.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@p1.id}_course_approved", visible: false

    assert_text "P2"
  end

  test "student can see subjects if they meet the requirements of the third operand" do
    visit root_path
    check "checkbox_#{@gal1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@gal1.id}_exam_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@p1.id}_course_approved", visible: false
    wait_for_async_request
    check "checkbox_#{@p1.id}_exam_approved", visible: false

    assert_text "P2"
  end
end
