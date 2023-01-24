require 'test_helper'

class SubjectPrerequisiteTest < ActiveSupport::TestCase
  test "#met? returns true when subject course is approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: false)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.course.id
    )
    assert prerequisite.met?([subject_needed.course.id])
  end

  test "#met? returns false when subject course is not approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: false)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.course.id
    )
    assert_not prerequisite.met?([])
  end

  test "#met? returns true when subject exam is approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: true)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.exam.id
    )

    assert prerequisite.met?([subject_needed.course.id, subject_needed.exam.id])
  end

  test "#met? return false when subject exam is not approved" do
    subject = create_subject(exam: false)
    subject_needed = create_subject(exam: true)
    prerequisite = SubjectPrerequisite.create!(
      approvable_id: subject.course.id,
      approvable_needed_id: subject_needed.exam.id
    )

    assert_not prerequisite.met?([subject_needed.course.id])
  end
end
