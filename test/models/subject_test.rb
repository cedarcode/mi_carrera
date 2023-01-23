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
    assert_equal 33, Subject.approved_credits([s1.id, s2.id, s3.id], [s1.id, s2.id, s3.id])
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

  test "#available? returns true when subject's course is available" do
    subject = create_subject(exam: false)
    mock = Minitest::Mock.new
    mock.expect(:available?, true, [[], []])

    subject.stub(:course, mock) do
      assert subject.available?([], [])
    end
  end

  test "#available? returns false when subject's course is not available" do
    subject = create_subject(exam: false)
    mock = Minitest::Mock.new
    mock.expect(:available?, false, [[], []])

    subject.stub(:course, mock) do
      assert_not subject.available?([], [])
    end
  end

  test "#with_exam returns subjects that require exam" do
    s1 = create_subject(exam: false) # rubocop:disable Lint/UselessAssignment
    s2 = create_subject(exam: true)

    assert_equal [s2], Subject.with_exam
  end

  test "#without_exam returns subjects that do not require exam" do
    s1 = create_subject(exam: false)
    s2 = create_subject(exam: true) # rubocop:disable Lint/UselessAssignment

    assert_equal [s1], Subject.without_exam
  end

  test "#ordered_by_semester_and_name returns subjects ordered by semester and name" do
    s1 = create_subject(semester: 1, name: 'A', code: 'A1')
    s2 = create_subject(semester: 1, name: 'B', code: 'B1')
    s3 = create_subject(semester: 2, name: 'A', code: 'A2')

    assert_equal [s1, s2, s3], Subject.ordered_by_semester_and_name
  end
end
