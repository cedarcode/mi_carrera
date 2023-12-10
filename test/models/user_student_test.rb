require 'test_helper'

class UserStudentTest < ActiveSupport::TestCase
  test "#add adds approvable.id only if available" do
    subject1 = create :subject, :with_exam
    subject2 = create :subject, :with_exam

    create :subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course

    user = create :user
    student = UserStudent.new(user)

    student.add(subject2.course)

    assert_equal [], user.reload.approvals

    student.add(subject1.course)
    assert_equal [subject1.course.id], user.reload.approvals

    student.add(subject2.course)
    assert_equal [subject1.course.id, subject2.course.id], user.reload.approvals
  end

  test "#remove removes approvable.id and just the exam of the subject" do
    subject1 = create :subject, :with_exam
    subject2 = create :subject, :with_exam
    subject3 = create :subject, :with_exam
    subject4 = create :subject, :with_exam

    create :subject_prerequisite, approvable: subject2.course, approvable_needed: subject3.course
    create :subject_prerequisite, approvable: subject3.course, approvable_needed: subject1.course

    user = create :user,
                  approvals: [subject1.course.id, subject1.exam.id, subject2.course.id, subject3.course.id,
                              subject4.course.id]
    student = UserStudent.new(user)

    student.remove(subject1.course)

    assert_equal [subject2.course.id, subject3.course.id, subject4.course.id], user.reload.approvals
  end

  test "#available? returns true if subject_or_approvable is available" do
    subject1 = create :subject, :with_exam
    create :subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course

    user = create :user
    assert UserStudent.new(user).available?(subject1)
    assert UserStudent.new(user).available?(subject1.course)
    assert_not UserStudent.new(user).available?(subject1.exam)

    user.approvals = [subject1.course.id]
    assert UserStudent.new(user).available?(subject1.exam)
  end

  test "#approved? returns true if subject_or_approvable is approved" do
    subject1 = create :subject
    subject2 = create :subject, :with_exam

    assert_not UserStudent.new(create :user, approvals: []).approved?(subject1)
    assert_not UserStudent.new(create :user, approvals: []).approved?(subject1.course)
    assert UserStudent.new(create :user, approvals: [subject1.course.id]).approved?(subject1)
    assert UserStudent.new(create :user, approvals: [subject1.course.id]).approved?(subject1.course)

    assert_not UserStudent.new(create :user, approvals: []).approved?(subject2)
    assert_not UserStudent.new(create :user, approvals: []).approved?(subject2.course)
    assert_not UserStudent.new(create :user, approvals: []).approved?(subject2.exam)
    assert_not UserStudent.new(create :user, approvals: [subject2.course.id]).approved?(subject2)

    assert UserStudent.new(create :user, approvals: [subject2.exam.id]).approved?(subject2)
    assert_not UserStudent.new(create :user, approvals: [subject2.exam.id]).approved?(subject2.course)
    assert UserStudent.new(create :user, approvals: [subject2.exam.id]).approved?(subject2.exam)
  end

  test "#group_credits returns approved credits for the given group" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create :subject, credits: 10, group: group1
    subject2 = create :subject, :with_exam, credits: 11, group: group1
    subject3 = create :subject, credits: 12, group: group2

    user = create :user, approvals: []
    assert_equal 0, UserStudent.new(user).group_credits(group1)
    user = create :user, approvals: [subject1.course.id]
    assert_equal 10, UserStudent.new(user).group_credits(group1)
    user = create :user, approvals: [subject1.course.id, subject2.course.id]
    assert_equal 10, UserStudent.new(user).group_credits(group1)
    user = create :user, approvals: [subject1.course.id, subject2.exam.id]
    assert_equal 21, UserStudent.new(user).group_credits(group1)
    user = create :user, approvals: [subject1.course.id, subject2.exam.id, subject3.course.id]
    assert_equal 21, UserStudent.new(user).group_credits(group1)
  end

  test "#total_credits returns total approved credits" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create :subject, credits: 10, group: group1
    subject2 = create :subject, :with_exam, credits: 11, group: group1
    subject3 = create :subject, credits: 12, group: group2

    user = create :user, approvals: []
    assert_equal 0, UserStudent.new(user).total_credits
    user = create :user, approvals: [subject1.course.id]
    assert_equal 10, UserStudent.new(user).total_credits
    user = create :user, approvals: [subject1.course.id, subject2.course.id]
    assert_equal 10, UserStudent.new(user).total_credits
    user = create :user, approvals: [subject1.course.id, subject2.exam.id]
    assert_equal 21, UserStudent.new(user).total_credits
    user = create :user, approvals: [subject1.course.id, subject2.exam.id, subject3.course.id]
    assert_equal 33, UserStudent.new(user).total_credits
  end

  test "#add of subject.exam adds subject.course as well" do
    subject = create :subject, :with_exam
    user = create :user, approvals: []
    student = UserStudent.new(user)
    student.add(subject.exam)

    assert_equal [subject.exam.id, subject.course.id], user.reload.approvals
  end

  test "#met? returns true if prerequisite met" do
    subject1 = create :subject, :with_exam
    prereq = create(:subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course)

    assert_not UserStudent.new(create :user, approvals: []).met?(prereq)
    assert UserStudent.new(create :user, approvals: [subject1.course.id]).met?(prereq)
  end

  test "#group_credits_met? returns true if group credits met" do
    group = create :subject_group, credits_needed: 10
    subject1 = create :subject, credits: 5, group: group
    subject2 = create :subject, credits: 5, group: group
    user = create :user, approvals: [subject1.course.id]

    assert_not UserStudent.new(user).group_credits_met?(group)
    user.approvals = [subject1.course.id, subject2.course.id]
    assert UserStudent.new(user).group_credits_met?(group)
  end
end
