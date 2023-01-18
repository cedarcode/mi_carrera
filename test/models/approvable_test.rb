require 'test_helper'

class ApprovableTest < ActiveSupport::TestCase
  test "#approved? returns true when not is_exam and course approved" do
    subject = create_subject(exam: true)
    course = subject.course

    assert_not course.approved?([], [])
    assert course.approved?([subject.id], [])
  end

  test "#approved? returns true when is_exam and exam approved" do
    subject = create_subject(exam: true)
    exam = subject.exam

    assert_not exam.approved?([], [])
    assert_not exam.approved?([subject.id], [])
    assert exam.approved?([], [subject.id])
  end
end
