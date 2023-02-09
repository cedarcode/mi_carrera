require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  test "#approved_credits returns approved credits" do
    s1 = create :subject, credits: 10
    s2 = create :subject, credits: 11
    s3 = create :subject, :with_exam, credits: 12

    assert_equal 0, Subject.approved_credits([])
    assert_equal 10, Subject.approved_credits([s1.course.id])
    assert_equal 21, Subject.approved_credits([s1.course.id, s2.course.id])
    assert_equal 21, Subject.approved_credits([s1.course.id, s2.course.id, s3.course.id])
    assert_equal 33, Subject.approved_credits([s1.course.id, s2.course.id, s3.course.id, s3.exam.id])
  end

  test "#approved? returns true when exam not required and course approved" do
    subject = create :subject

    assert_not subject.approved?([])
    assert subject.approved?([subject.course.id])
  end

  test "#approved? returns true when exam required and exam approved" do
    subject = create :subject, :with_exam

    assert_not subject.approved?([])
    assert_not subject.approved?([subject.course.id])
    assert subject.approved?([subject.course.id, subject.exam.id])
  end

  test "#available? returns true when subject's course is available" do
    subject = create :subject
    mock = Minitest::Mock.new
    mock.expect(:available?, true, [[]])

    subject.stub(:course, mock) do
      assert subject.available?([])
    end
  end

  test "#available? returns false when subject's course is not available" do
    subject = create :subject
    mock = Minitest::Mock.new
    mock.expect(:available?, false, [[], []])

    subject.stub(:course, mock) do
      assert_not subject.available?([], [])
    end
  end

  test "#with_exam returns subjects that require exam" do
    create :subject
    s2 = create :subject, :with_exam

    assert_equal [s2], Subject.with_exam
  end

  test "#without_exam returns subjects that do not require exam" do
    s1 = create :subject
    create :subject, :with_exam

    assert_equal [s1], Subject.without_exam
  end

  test "#ordered_by_semester_and_name returns subjects ordered by semester and name" do
    s1 = create :subject, :with_exam, semester: 1, name: 'A', code: 'A1'
    s2 = create :subject, :with_exam, semester: 1, name: 'B', code: 'B1'
    s3 = create :subject, :with_exam, semester: 2, name: 'A', code: 'A2'

    assert_equal [s1, s2, s3], Subject.ordered_by_semester_and_name
  end
end
