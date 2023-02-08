require 'test_helper'

class SessionStudentTest < ActiveSupport::TestCase
  test "#add adds approvable.id only if available" do
    subject1 = create_subject
    subject2 = create_subject

    SubjectPrerequisite.create!(approvable_id: subject2.course.id, approvable_needed: subject1.course)

    session = {}
    student = SessionStudent.new(session)

    student.add(subject2.course)

    assert_nil session[:approved_approvable_ids]

    student.add(subject1.course)
    assert_equal [subject1.course.id], session[:approved_approvable_ids]

    student.add(subject2.course)
    assert_equal [subject1.course.id, subject2.course.id], session[:approved_approvable_ids]
  end

  test "#remove removes approvable.id and other approvables that are not available anymore" do
    subject1 = create_subject
    subject2 = create_subject
    subject3 = create_subject
    subject4 = create_subject

    SubjectPrerequisite.create!(approvable_id: subject2.course.id, approvable_needed: subject3.course)
    SubjectPrerequisite.create!(approvable_id: subject3.course.id, approvable_needed: subject1.course)

    session = {
      approved_approvable_ids: [subject1.course.id, subject2.course.id, subject3.course.id, subject4.course.id]
    }
    student = SessionStudent.new(session)

    student.remove(subject1.course)

    assert_equal [subject4.course.id], session[:approved_approvable_ids]
  end

  test "#available? returns true if subject_or_approvable is available" do
    subject1 = create_subject
    SubjectPrerequisite.create!(approvable_id: subject1.exam.id, approvable_needed: subject1.course)

    assert SessionStudent.new({ approved_approvable_ids: [] }).available?(subject1)
    assert SessionStudent.new({ approved_approvable_ids: [] }).available?(subject1.course)
    assert_not SessionStudent.new({ approved_approvable_ids: [] }).available?(subject1.exam)
    assert SessionStudent.new({ approved_approvable_ids: [subject1.course.id] }).available?(subject1.exam)
  end

  test "#approved? returns true if subject_or_approvable is approved" do
    subject1 = create_subject(exam: false)
    subject2 = create_subject

    assert_not SessionStudent.new({ approved_approvable_ids: [] }).approved?(subject1)
    assert_not SessionStudent.new({ approved_approvable_ids: [] }).approved?(subject1.course)
    assert SessionStudent.new({ approved_approvable_ids: [subject1.course.id] }).approved?(subject1)
    assert SessionStudent.new({ approved_approvable_ids: [subject1.course.id] }).approved?(subject1.course)

    assert_not SessionStudent.new({ approved_approvable_ids: [] }).approved?(subject2)
    assert_not SessionStudent.new({ approved_approvable_ids: [] }).approved?(subject2.course)
    assert_not SessionStudent.new({ approved_approvable_ids: [] }).approved?(subject2.exam)
    assert_not SessionStudent.new({ approved_approvable_ids: [subject2.course.id] }).approved?(subject2)

    assert SessionStudent.new({ approved_approvable_ids: [subject2.exam.id] }).approved?(subject2)
    assert_not SessionStudent.new({ approved_approvable_ids: [subject2.exam.id] }).approved?(subject2.course)
    assert SessionStudent.new({ approved_approvable_ids: [subject2.exam.id] }).approved?(subject2.exam)
  end

  test "#group_credits returns approved credits for the given group" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create_subject(credits: 10, exam: false, group: group1)
    subject2 = create_subject(credits: 11, exam: true, group: group1)
    subject3 = create_subject(credits: 12, exam: false, group: group2)

    student = SessionStudent.new(approved_approvable_ids: [])
    assert_equal 0, student.group_credits(group1)
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id])
    assert_equal 10, student.group_credits(group1)
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.course.id])
    assert_equal 10, student.group_credits(group1)
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.exam.id])
    assert_equal 21, student.group_credits(group1)
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 21, student.group_credits(group1)
  end

  test "#total_credits returns total approved credits" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create_subject(credits: 10, exam: false, group: group1)
    subject2 = create_subject(credits: 11, exam: true, group: group1)
    subject3 = create_subject(credits: 12, exam: false, group: group2)

    student = SessionStudent.new(approved_approvable_ids: [])
    assert_equal 0, student.total_credits
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id])
    assert_equal 10, student.total_credits
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.course.id])
    assert_equal 10, student.total_credits
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.exam.id])
    assert_equal 21, student.total_credits
    student = SessionStudent.new(approved_approvable_ids: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 33, student.total_credits
  end

  test "#add subject.exam adds subject.course as well" do
    subject = create_subject(exam: true)
    session = { approved_approvable_ids: [] }
    student = SessionStudent.new(session)
    student.add(subject.exam)

    assert_equal [subject.exam.id, subject.course.id], session[:approved_approvable_ids]
  end
end
