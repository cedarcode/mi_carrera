require 'test_helper'

class SubjectPrerequisiteTest < ActiveSupport::TestCase
  test "#met? returns true when subject course is approved" do
    subject_needed = create :subject
    prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.course
    assert prerequisite.met?([subject_needed.course.id])
  end

  test "#met? returns false when subject course is not approved" do
    subject_needed = create :subject
    prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.course
    assert_not prerequisite.met?([])
  end

  test "#met? returns true when subject exam is approved" do
    subject_needed = create :subject, :with_exam
    prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.exam

    assert prerequisite.met?([subject_needed.course.id, subject_needed.exam.id])
  end

  test "#met? return false when subject exam is not approved" do
    subject_needed = create :subject, :with_exam
    prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.exam

    assert_not prerequisite.met?([subject_needed.course.id])
  end
end
