require 'rails_helper'
require 'support/cookies_helper'

RSpec.describe CookieStudent, type: :model do
  include CookiesHelper

  describe '#add' do
    it 'adds approvable.id only if available' do
      subject1 = create :subject, :with_exam
      subject2 = create :subject, :with_exam

      create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)

      student.add(subject2.course)
      expect(approvable_ids_in_cookie(cookies)).to be_nil

      student.add(subject1.course)
      expect(approvable_ids_in_cookie(cookies)).to eq([subject1.course.id])

      student.add(subject2.course)
      expect(approvable_ids_in_cookie(cookies)).to eq([subject1.course.id, subject2.course.id])
    end

    it 'for a subject.exam adds subject.course as well' do
      subject = create :subject, :with_exam
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)
      student.add(subject.exam)

      expect(approvable_ids_in_cookie(cookies)).to eq([subject.exam.id, subject.course.id])
    end
  end

  describe '#remove' do
    it 'removes approvable.id and just the exam of the subject' do
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

      expect(approvable_ids_in_cookie(cookies)).to eq([subject2.course.id, subject3.course.id, subject4.course.id])
    end
  end

  describe '#force_add_subject' do
    it 'adds both course and exam ids to approvals' do
      subject = create :subject, :with_exam
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)

      student.force_add_subject(subject)
      expect(approvable_ids_in_cookie(cookies)).to contain_exactly(subject.course.id, subject.exam.id)
    end

    it 'adds only course id when subject has no exam' do
      subject = create :subject
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)

      student.force_add_subject(subject)
      expect(approvable_ids_in_cookie(cookies)).to eq([subject.course.id])
    end

    it 'adds ids even if they already exist' do
      subject = create :subject, :with_exam
      cookies = build(:cookie, approved_approvable_ids: [subject.course.id])
      student = build(:cookie_student, cookies:)

      student.force_add_subject(subject)
      expect(approvable_ids_in_cookie(cookies)).to eq([subject.course.id, subject.exam.id])
    end
  end

  describe '#available?' do
    it 'returns true if subject_or_approvable is available' do
      subject1 = create :subject, :with_exam
      create(:subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course)

      expect(build(:cookie_student, approved_approvable_ids: []).available?(subject1)).to be true
      expect(build(:cookie_student, approved_approvable_ids: []).available?(subject1.course)).to be true
      expect(build(:cookie_student, approved_approvable_ids: []).available?(subject1.exam)).to be false

      cookies = build(:cookie, approved_approvable_ids: [subject1.course.id])
      expect(build(:cookie_student, cookies:).available?(subject1)).to be true
    end
  end

  describe '#approved?' do
    it 'returns true if subject_or_approvable is approved' do
      subject1 = create :subject
      subject2 = create :subject, :with_exam

      expect(build(:cookie_student, approved_approvable_ids: []).approved?(subject1)).to be false
      expect(build(:cookie_student, approved_approvable_ids: []).approved?(subject1.course)).to be false
      expect(build(:cookie_student, approved_approvable_ids: [subject1.course.id]).approved?(subject1)).to be true
      expect(build(:cookie_student, approved_approvable_ids: [subject1.course.id])
                  .approved?(subject1.course)).to be true
      expect(build(:cookie_student, approved_approvable_ids: []).approved?(subject2)).to be false
      expect(build(:cookie_student, approved_approvable_ids: []).approved?(subject2.course)).to be false
      expect(build(:cookie_student, approved_approvable_ids: []).approved?(subject2.exam)).to be false
      expect(build(:cookie_student, approved_approvable_ids: [subject2.course.id]).approved?(subject2)).to be false
      expect(build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2)).to be true
      expect(build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2.course)).to be false
      expect(build(:cookie_student, approved_approvable_ids: [subject2.exam.id]).approved?(subject2.exam)).to be true
    end
  end

  describe '#group_credits' do
    it 'returns approved credits for the given group' do
      group1 = create :subject_group
      group2 = create :subject_group

      subject1 = create :subject, credits: 10, group: group1
      subject2 = create :subject, :with_exam, credits: 11, group: group1
      subject3 = create :subject, credits: 12, group: group2

      expect(build(:cookie_student, approved_approvable_ids: []).group_credits(group1)).to eq(0)
      expect(build(:cookie_student, approved_approvable_ids: [subject1.course.id]).group_credits(group1)).to eq(10)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.course.id]).group_credits(group1)).to eq(10)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.exam.id]).group_credits(group1)).to eq(21)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.exam.id,
                                             subject3.course.id]).group_credits(group1)).to eq(21)
    end
  end

  describe '#total_credits' do
    it 'returns total approved credits' do
      group1 = create :subject_group
      group2 = create :subject_group

      subject1 = create :subject, credits: 10, group: group1
      subject2 = create :subject, :with_exam, credits: 11, group: group1
      subject3 = create :subject, credits: 12, group: group2

      expect(build(:cookie_student, approved_approvable_ids: []).total_credits).to eq(0)
      expect(build(:cookie_student, approved_approvable_ids: [subject1.course.id]).total_credits).to eq(10)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.course.id]).total_credits).to eq(10)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.exam.id]).total_credits).to eq(21)
      expect(build(:cookie_student,
                   approved_approvable_ids: [subject1.course.id, subject2.exam.id,
                                             subject3.course.id]).total_credits).to eq(33)
    end
  end

  describe '#met?' do
    it 'returns true if prerequisite met' do
      subject1 = create :subject, :with_exam
      prereq = create(:subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course)

      expect(build(:cookie_student, approved_approvable_ids: [])).not_to be_met(prereq)
      expect(build(:cookie_student, approved_approvable_ids: [subject1.course.id])).to be_met(prereq)
    end
  end

  describe '#group_credits_met?' do
    it 'returns true if group credits met' do
      group = create :subject_group, credits_needed: 10
      subject1 = create :subject, credits: 5, group: group
      subject2 = create :subject, credits: 5, group: group
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)
      student.add(subject1.course)

      expect(student.group_credits_met?(group)).to be false
      student.add(subject2.course)
      expect(student.group_credits_met?(group)).to be true
    end
  end

  describe '#groups_credits_met?' do
    it 'returns true if all groups credits met' do
      group1 = create :subject_group, credits_needed: 10
      group2 = create :subject_group, credits_needed: 10
      subject1 = create :subject, credits: 10, group: group1
      subject2 = create :subject, credits: 10, group: group2
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)

      expect(student.groups_credits_met?).to be false
      student.add(subject1.course)
      expect(student.groups_credits_met?).to be false
      student.add(subject2.course)
      expect(student.groups_credits_met?).to be true
    end
  end

  describe '#graduated?' do
    it 'returns true if total credits >= 450 and all groups credits met' do
      group = create :subject_group, credits_needed: 10
      subject1 = create :subject, credits: 440, group: group
      subject2 = create :subject, credits: 10, group: group
      cookies = build(:cookie)
      student = build(:cookie_student, cookies:)

      expect(student).not_to be_graduated
      student.add(subject1.course)
      expect(student).not_to be_graduated
      student.add(subject2.course)
      expect(student).to be_graduated
    end
  end

  describe '#degree' do
    let(:student) { build(:cookie_student, cookies:) }
    let(:cookies) { build(:cookie) }

    it 'returns default degree' do
      expect(student.degree).to eq(Degree.default)
    end
  end

  describe "#approved_subjects" do
    it "returns approved subjects for the student" do
      subject1 = create(:subject, :with_exam)
      subject2 = create(:subject, :with_exam)
      cookies = build(:cookie, approved_approvable_ids: [subject1.course.id, subject2.exam.id])
      student = build(:cookie_student, cookies:)

      expect(student.approved_subjects).to contain_exactly(subject2)
    end
  end
end
