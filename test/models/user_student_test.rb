require 'test_helper'

class UserStudentTest < ActiveSupport::TestCase
  test "#add adds approvable.id only if available" do
    subject1 = create_subject
    subject2 = create_subject

    SubjectPrerequisite.create!(approvable_id: subject2.course.id, approvable_needed: subject1.course)

    user = create_user
    student = UserStudent.new(user)

    student.add(subject2.course)

    assert_equal [], user.reload.approvals

    student.add(subject1.course)
    assert_equal [subject1.course.id], user.reload.approvals

    student.add(subject2.course)
    assert_equal [subject1.course.id, subject2.course.id], user.reload.approvals
  end

  test "#remove removes approvable.id and other approvables that are not available anymore" do
    subject1 = create_subject
    subject2 = create_subject
    subject3 = create_subject
    subject4 = create_subject

    SubjectPrerequisite.create!(approvable_id: subject2.course.id, approvable_needed: subject3.course)
    SubjectPrerequisite.create!(approvable_id: subject3.course.id, approvable_needed: subject1.course)

    user = create_user(approvals: [subject1.course.id, subject2.course.id, subject3.course.id, subject4.course.id])
    student = UserStudent.new(user)

    student.remove(subject1.course)

    assert_equal [subject4.course.id], user.reload.approvals
  end

  test "#available? returns true if subject_or_approvable is available" do
    subject1 = create_subject
    SubjectPrerequisite.create!(approvable_id: subject1.exam.id, approvable_needed: subject1.course)

    assert UserStudent.new(create_user).available?(subject1)
    assert UserStudent.new(create_user).available?(subject1.course)
    assert_not UserStudent.new(create_user).available?(subject1.exam)
    assert UserStudent.new(create_user(approvals: [subject1.course.id])).available?(subject1.exam)
  end

  test "#approved? returns true if subject_or_approvable is approved" do
    subject1 = create_subject(exam: false)
    subject2 = create_subject

    assert_not UserStudent.new(create_user(approvals: [])).approved?(subject1)
    assert_not UserStudent.new(create_user(approvals: [])).approved?(subject1.course)
    assert UserStudent.new(create_user(approvals: [subject1.course.id])).approved?(subject1)
    assert UserStudent.new(create_user(approvals: [subject1.course.id])).approved?(subject1.course)

    assert_not UserStudent.new(create_user(approvals: [])).approved?(subject2)
    assert_not UserStudent.new(create_user(approvals: [])).approved?(subject2.course)
    assert_not UserStudent.new(create_user(approvals: [])).approved?(subject2.exam)
    assert_not UserStudent.new(create_user(approvals: [subject2.course.id])).approved?(subject2)

    assert UserStudent.new(create_user(approvals: [subject2.exam.id])).approved?(subject2)
    assert_not UserStudent.new(create_user(approvals: [subject2.exam.id])).approved?(subject2.course)
    assert UserStudent.new(create_user(approvals: [subject2.exam.id])).approved?(subject2.exam)
  end

  test "#group_credits returns approved credits for the given group" do
    group1 = create_group
    group2 = create_group

    subject1 = create_subject(credits: 10, exam: false, group: group1)
    subject2 = create_subject(credits: 11, exam: true, group: group1)
    subject3 = create_subject(credits: 12, exam: false, group: group2)

    user = create_user(approvals: [])
    assert_equal 0, UserStudent.new(user).group_credits(group1)
    user = create_user(approvals: [subject1.course.id])
    assert_equal 10, UserStudent.new(user).group_credits(group1)
    user = create_user(approvals: [subject1.course.id, subject2.course.id])
    assert_equal 10, UserStudent.new(user).group_credits(group1)
    user = create_user(approvals: [subject1.course.id, subject2.exam.id])
    assert_equal 21, UserStudent.new(user).group_credits(group1)
    user = create_user(approvals: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 21, UserStudent.new(user).group_credits(group1)
  end

  test "#total_credits returns total approved credits" do
    group1 = create_group
    group2 = create_group

    subject1 = create_subject(credits: 10, exam: false, group: group1)
    subject2 = create_subject(credits: 11, exam: true, group: group1)
    subject3 = create_subject(credits: 12, exam: false, group: group2)

    user = create_user(approvals: [])
    assert_equal 0, UserStudent.new(user).total_credits
    user = create_user(approvals: [subject1.course.id])
    assert_equal 10, UserStudent.new(user).total_credits
    user = create_user(approvals: [subject1.course.id, subject2.course.id])
    assert_equal 10, UserStudent.new(user).total_credits
    user = create_user(approvals: [subject1.course.id, subject2.exam.id])
    assert_equal 21, UserStudent.new(user).total_credits
    user = create_user(approvals: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 33, UserStudent.new(user).total_credits
  end

  test "#add of subject.exam adds subject.course as well" do
    subject = create_subject(exam: true)
    user = create_user(approvals: [])
    student = UserStudent.new(user)
    student.add(subject.exam)

    assert_equal [subject.course.id, subject.exam.id].sort, user.reload.approvals.sort
  end
end
