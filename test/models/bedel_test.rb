require 'test_helper'

class BedelTest < ActiveSupport::TestCase
  test "approve first version" do
    @subject1 = create_subject(name: "Subject 1", credits: 16, exam: false)
    @subject2 = create_subject(name: "Subject 2", credits: 13, exam: false)

    create_prerequisite(@subject2.course, not: @subject1.course)

    bedel = Bedel.new({})

    assert(bedel.able_to_do?(@subject2.course))

    bedel.add_approval(@subject1.course)
    assert_not(bedel.able_to_do?(@subject2.course))
  end

  test "#enrollment_state returns :enabled when course be able to enroll" do
    bedel = Bedel.new

    subject1_old = create_subject(name: "Subject 1 (Old)")
    subject1_new = create_subject(name: "Subject 1 (New)")

    create_prerequisite(subject1_old.course, not: subject1_new.course)
    create_prerequisite(subject1_new.course, not: subject1_old.course)

    assert_equal(:yes, bedel.enrollment_state(subject1_old))
  end

  test "#enrollment_state returns :never when course will never be able to enroll" do
    bedel = Bedel.new

    subject1_old = create_subject(name: "Subject 1 (Old)")
    subject1_new = create_subject(name: "Subject 1 (New)")

    create_prerequisite(subject1_old.course, not: subject1_new.course)
    create_prerequisite(subject1_new.course, not: subject1_old.course)

    bedel.add_approval(subject1_new.course)

    assert_equal(:never, bedel.enrollment_state(subject1_old))
  end

  test "#enrollment_state returns :locked when course will be able to enroll if more prerequisites are approved" do
    bedel = Bedel.new

    subject1_old = create_subject(name: "Subject 1 (Old)")
    subject1_new = create_subject(name: "Subject 1 (New)")
    subject2 = create_subject(name: "Subject 2")

    create_prerequisite(subject1_old.course, not: subject1_new.course)
    create_prerequisite(subject1_new.course, not: subject1_old.course)
    create_prerequisite(subject2.course, subject1_new.course)

    assert_equal(:not_yet, bedel.enrollment_state(subject2))

    bedel.add_approval(subject1_old.course)

    assert_equal(:never, bedel.enrollment_state(subject2))
  end
end
