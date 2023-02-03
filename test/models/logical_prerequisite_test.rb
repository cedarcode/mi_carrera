require 'test_helper'

class LogicalPrerequisiteTest < ActiveSupport::TestCase
  setup do
    @subject1 = create :subject
    @subject2 = create :subject
  end

  test "#met? on logical AND returns true when all prerequisites met" do
    prerequisite = build(:and_prerequisite, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: @subject1.course),
      create(:subject_prerequisite, approvable_needed: @subject2.course)
    ])

    assert_not prerequisite.met?([@subject1.course.id])
    assert prerequisite.met?([@subject1.course.id, @subject2.course.id])
  end

  test "#met? on logical OR returns true when any prerequisite met" do
    prerequisite = build(:or_prerequisite, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: @subject1.course),
      create(:subject_prerequisite, approvable_needed: @subject2.course)
    ])

    assert_not prerequisite.met?([])
    assert prerequisite.met?([@subject1.course.id])
    assert prerequisite.met?([@subject2.course.id])
  end

  test "#met? on logical NOT returns true when prerequisite not met" do
    prerequisite = build(:not_prerequisite, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: @subject1.course)
    ])

    assert prerequisite.met?([])
    assert_not prerequisite.met?([@subject1.course.id])
  end

  test "#met? on logical AT_LEAST returns true conditions are met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "at_least",
      amount_of_subjects_needed: 2,
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id),
      ]
    )

    assert prerequisite.met?([@subject2.course.id, @subject3.course.id])
  end

  test "#met? on logical AT_LEAST returns false when any prerequisite not met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "at_least",
      amount_of_subjects_needed: 2,
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert_not prerequisite.met?([@subject2.course.id])
  end

  test "validates that the amount of subjects is loe than operand prerequisites count" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "at_least",
      amount_of_subjects_needed: 3,
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert_not prerequisite.valid?
  end
end
