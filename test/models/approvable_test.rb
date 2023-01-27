require 'test_helper'

class ApprovableTest < ActiveSupport::TestCase
  test "#approved? returns true when not is_exam and course approved" do
    subject = create_subject(exam: true)
    course = subject.course

    assert_not course.approved?([])
    assert course.approved?([subject.course.id])
  end

  test "#approved? returns true when is_exam and exam approved" do
    subject = create_subject(exam: true)
    exam = subject.exam

    assert_not exam.approved?([])
    assert_not exam.approved?([subject.course.id])
    assert exam.approved?([subject.course.id, subject.exam.id])
  end

  test "#available? returns true when no prerequisite" do
    subject = create_subject(exam: false)
    course = subject.course

    assert course.available?([])
  end

  test "#available? returns true when prerequisite met" do
    subject1 = create_subject(exam: false)
    subject2 = create_subject(exam: false)

    mock = Minitest::Mock.new
    mock.expect(:met?, true, [[subject1.course.id]])

    subject2.course.stub(:prerequisite_tree, mock) do
      assert subject2.course.available?([subject1.course.id])
    end
  end

  test "#available? returns false when prerequisite not met" do
    subject1 = create_subject(exam: false)
    subject2 = create_subject(exam: false)

    mock = Minitest::Mock.new
    mock.expect(:met?, false, [[subject1.course.id]])

    subject2.course.stub(:prerequisite_tree, mock) do
      assert_not subject2.course.available?([subject1.course.id])
    end
  end
end
