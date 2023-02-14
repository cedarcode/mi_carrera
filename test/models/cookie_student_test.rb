require 'test_helper'

class CookieStudentTest < ActiveSupport::TestCase
  test "#add adds approvable.id only if available" do
    subject1 = create :subject, :with_exam
    subject2 = create :subject, :with_exam

    create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

    cookies = build(:cookie)
    student = build(:cookie_student, cookies:)

    student.add(subject2.course)

    assert_nil approvable_ids_in_cookie(cookies)

    student.add(subject1.course)
    assert_equal [subject1.course.id], approvable_ids_in_cookie(cookies)

    student.add(subject2.course)
    assert_equal [subject1.course.id, subject2.course.id], approvable_ids_in_cookie(cookies)
  end

  test "#remove removes approvable.id and just the exam of the subject" do
    subject1 = create :subject, :with_exam
    subject2 = create :subject, :with_exam
    subject3 = create :subject, :with_exam
    subject4 = create :subject, :with_exam

    create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject3.course)
    create(:subject_prerequisite, approvable: subject3.course, approvable_needed: subject1.course)

    cookies = build(:cookie,
                    approved_approvable_ids: [
                      subject1.course.id,
                      subject2.course.id,
                      subject3.course.id,
                      subject4.course.id
                    ])
    student = build(:cookie_student, cookies:)
    student.remove(subject1.course)

    assert_equal [subject2.course.id, subject3.course.id, subject4.course.id], approvable_ids_in_cookie(cookies)
  end

  test "#available? returns true if subject_or_approvable is available" do
    subject1 = create :subject, :with_exam
    create(:subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course)

    assert build(:cookie_student, approved_approvable_ids: []).available?(subject1)
    assert build(:cookie_student, approved_approvable_ids: []).available?(subject1.course)
    assert_not build(:cookie_student, approved_approvable_ids: []).available?(subject1.exam)

    cookies = build(:cookie, approved_approvable_ids: [subject1.course.id])
    assert build(:cookie_student, cookies:).available?(subject1.exam)
  end

  test "#approved? returns true if subject_or_approvable is approved" do
    subject1 = create :subject
    subject2 = create :subject, :with_exam

    assert_not build(:cookie_student, approved_approvable_ids: []).approved?(subject1)
    assert_not build(:cookie_student, approved_approvable_ids: []).approved?(subject1.course)
    assert build(:cookie_student, approved_approvable_ids: [subject1.course.id]).approved?(subject1)
    assert build(:cookie_student, approved_approvable_ids: [subject1.course.id]).approved?(subject1.course)
    assert_not build(:cookie_student, approved_approvable_ids: []).approved?(subject2)
    assert_not build(:cookie_student, approved_approvable_ids: []).approved?(subject2.course)
    assert_not build(:cookie_student, approved_approvable_ids: []).approved?(subject2.exam)
    assert_not build(:cookie_student, approved_approvable_ids: [subject2.course.id]).approved?(subject2)
    assert build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2)
    assert_not build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2.course)
    assert build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2.exam)
  end

  test "#group_credits returns approved credits for the given group" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create :subject, credits: 10, group: group1
    subject2 = create :subject, :with_exam, credits: 11, group: group1
    subject3 = create :subject, credits: 12, group: group2

    student = build(:cookie_student, approved_approvable_ids: [])
    assert_equal 0, student.group_credits(group1)
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id])
    assert_equal 10, student.group_credits(group1)
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id, subject2.course.id])
    assert_equal 10, student.group_credits(group1)
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id, subject2.exam.id])
    assert_equal 21, student.group_credits(group1)
    student = build(:cookie_student,
                    approved_approvable_ids: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 21, student.group_credits(group1)
  end

  test "#total_credits returns total approved credits" do
    group1 = create :subject_group
    group2 = create :subject_group

    subject1 = create :subject, credits: 10, group: group1
    subject2 = create :subject, :with_exam, credits: 11, group: group1
    subject3 = create :subject, credits: 12, group: group2

    student = build(:cookie_student, approved_approvable_ids: [])
    assert_equal 0, student.total_credits
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id])
    assert_equal 10, student.total_credits
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id, subject2.course.id])
    assert_equal 10, student.total_credits
    student = build(:cookie_student, approved_approvable_ids: [subject1.course.id, subject2.exam.id])
    assert_equal 21, student.total_credits
    student = build(:cookie_student,
                    approved_approvable_ids: [subject1.course.id, subject2.exam.id, subject3.course.id])
    assert_equal 33, student.total_credits
  end

  test "#add subject.exam adds subject.course as well" do
    subject = create :subject, :with_exam
    cookies = build(:cookie)
    student = build(:cookie_student, cookies:)
    student.add(subject.exam)

    assert_equal [subject.exam.id, subject.course.id], approvable_ids_in_cookie(cookies)
  end
end
