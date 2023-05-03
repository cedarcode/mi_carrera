require 'test_helper'

class EnrollmentPrerequisiteTest < ActiveSupport::TestCase
  test "#met? returns false when subject course is approved" do
    subject_needed = create :subject
    prerequisite = create :enrollment_prerequisite, approvable_needed: subject_needed.course
    assert_not prerequisite.met?([subject_needed.course.id])
  end

  test "#met? returns false when subject course is not approved" do
    subject_needed = create :subject
    prerequisite = create :enrollment_prerequisite, approvable_needed: subject_needed.course
    assert_not prerequisite.met?([])
  end
end
