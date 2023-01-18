require 'test_helper'

class SubjectPrerequisiteTest < ActiveSupport::TestCase
  test "#met? returns true when subject is approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: false)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.course.id
    )
    assert prerequisite.met?([subject_needed.id], [])
  end

  test "#met? returns false when subject is not approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: false)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.course.id
    )
    assert_not prerequisite.met?([], [])
  end
end
