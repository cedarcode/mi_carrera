require 'test_helper'

class LogicalPrerequisiteTest < ActiveSupport::TestCase
  setup do
    @subject1 = create :subject
    @subject2 = create :subject
    @subject3 = create :subject
  end

  test "#met? on logical AND returns true when all prerequisites met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "and",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert prerequisite.met?([@subject2.course.id, @subject3.course.id])
  end

  test "#met? on logical AND returns false when any prerequisite not met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "and",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert_not prerequisite.met?([@subject2.course.id])
  end

  test "#met? on logical OR returns true when any prerequisite met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "or",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert prerequisite.met?([@subject2.course.id])
    assert prerequisite.met?([@subject3.course.id])
  end

  test "#met? on logical OR returns false when all prerequisites not met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "or",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id),
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject3.course.id)
      ]
    )

    assert_not prerequisite.met?([])
  end

  test "#met? on logical NOT returns true when prerequisite not met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "not",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id)
      ]
    )

    assert prerequisite.met?([])
  end

  test "#met? on logical NOT returns false when prerequisite met" do
    prerequisite = LogicalPrerequisite.new(
      logical_operator: "not",
      operands_prerequisites: [
        SubjectPrerequisite.create!(approvable_id: @subject1.course.id, approvable_needed_id: @subject2.course.id)
      ]
    )

    assert_not prerequisite.met?([@subject2.course.id])
  end
end
