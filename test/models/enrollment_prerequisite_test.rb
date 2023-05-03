require 'test_helper'

class EnrollmentPrerequisiteTest < ActiveSupport::TestCase
  test "#met? always returns false" do
    subject_needed = create :subject
    prerequisite = create :enrollment_prerequisite, approvable_needed: subject_needed.course
    assert_not prerequisite.met?([])
    assert_not prerequisite.met?([subject_needed.course.id])
  end
end
