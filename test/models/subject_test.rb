require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  test "#approved_credits returns approved credits" do
    s1 = create_subject(credits: 10, exam: false)
    s2 = create_subject(credits: 11, exam: false)
    s3 = create_subject(credits: 12, exam: true)

    assert_equal 0, Subject.approved_credits([], [])
    assert_equal 10, Subject.approved_credits([s1.id], [])
    assert_equal 21, Subject.approved_credits([s1.id, s2.id], [])
    assert_equal 21, Subject.approved_credits([s1.id, s2.id, s3.id], [])
    assert_equal 33, Subject.approved_credits([s1.id, s2.id, s3.id], [s3.id])
  end

  test "#approved? returns true when exam not required and course approved" do
    subject = create_subject(exam: false)

    assert_not subject.approved?([], [])
    assert subject.approved?([subject.id], [])
  end

  test "#approved? returns true when exam required and exam approved" do
    subject = create_subject(exam: true)

    assert_not subject.approved?([], [])
    assert_not subject.approved?([subject.id], [])
    assert subject.approved?([], [subject.id])
  end
end
