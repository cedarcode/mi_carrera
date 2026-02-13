require 'rails_helper'

RSpec.describe UserStudent, type: :model do
  describe '#add' do
    it 'adds approvable.id only if available' do
      subject1 = create :subject, :with_exam
      subject2 = create :subject, :with_exam

      create :subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course

      user = create :user
      student = described_class.new(user)

      student.add(subject2.course)
      expect(user.reload.approvals).to eq([])

      student.add(subject1.course)
      expect(user.reload.approvals).to eq([subject1.course.id])

      student.add(subject2.course)
      expect(user.reload.approvals).to eq([subject1.course.id, subject2.course.id])
    end

    it 'adds subject.exam adds subject.course as well' do
      subject = create :subject, :with_exam
      user = create :user, approvals: []
      student = described_class.new(user)
      student.add(subject.exam)

      expect(user.reload.approvals).to eq([subject.exam.id, subject.course.id])
    end
  end

  describe '#remove' do
    it 'removes approvable.id and just the exam of the subject' do
      subject1 = create :subject, :with_exam
      subject2 = create :subject, :with_exam
      subject3 = create :subject, :with_exam
      subject4 = create :subject, :with_exam

      create :subject_prerequisite, approvable: subject2.course, approvable_needed: subject3.course
      create :subject_prerequisite, approvable: subject3.course, approvable_needed: subject1.course

      user = create :user,
                    approvals: [subject1.course.id, subject1.exam.id, subject2.course.id, subject3.course.id,
                                subject4.course.id]
      student = described_class.new(user)

      student.remove(subject1.course)

      expect(user.reload.approvals).to eq([subject2.course.id, subject3.course.id, subject4.course.id])
    end
  end

  describe '#available?' do
    it 'returns true if subject_or_approvable is available' do
      subject1 = create :subject, :with_exam
      create :subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course

      user = create :user
      expect(described_class.new(user).available?(subject1)).to be true
      expect(described_class.new(user).available?(subject1.course)).to be true
      expect(described_class.new(user).available?(subject1.exam)).to be false

      user.approvals = [subject1.course.id]
      expect(described_class.new(user).available?(subject1.exam)).to be true
    end
  end

  describe '#approved?' do
    it 'returns true if subject_or_approvable is approved' do
      subject1 = create :subject
      subject2 = create :subject, :with_exam

      expect(described_class.new(create :user, approvals: []).approved?(subject1)).to be false
      expect(described_class.new(create :user, approvals: []).approved?(subject1.course)).to be false
      expect(described_class.new(create :user, approvals: [subject1.course.id]).approved?(subject1)).to be true
      expect(described_class.new(create :user, approvals: [subject1.course.id]).approved?(subject1.course)).to be true

      expect(described_class.new(create :user, approvals: []).approved?(subject2)).to be false
      expect(described_class.new(create :user, approvals: []).approved?(subject2.course)).to be false
      expect(described_class.new(create :user, approvals: []).approved?(subject2.exam)).to be false
      expect(described_class.new(create :user, approvals: [subject2.course.id]).approved?(subject2)).to be false

      expect(described_class.new(create :user, approvals: [subject2.exam.id]).approved?(subject2)).to be true
      expect(described_class.new(create :user, approvals: [subject2.exam.id]).approved?(subject2.course)).to be false
      expect(described_class.new(create :user, approvals: [subject2.exam.id]).approved?(subject2.exam)).to be true
    end
  end

  describe '#group_credits' do
    it 'returns approved credits for the given group' do
      group1 = create :subject_group
      group2 = create :subject_group

      subject1 = create :subject, credits: 10, group: group1
      subject2 = create :subject, :with_exam, credits: 11, group: group1
      subject3 = create :subject, credits: 12, group: group2

      expect(described_class.new(create :user, approvals: []).group_credits(group1)).to eq(0)
      expect(described_class.new(create :user, approvals: [subject1.course.id]).group_credits(group1)).to eq(10)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id,
                                                    subject2.course.id]).group_credits(group1)).to eq(10)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id,
                                                    subject2.exam.id]).group_credits(group1)).to eq(21)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id, subject2.exam.id,
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

      expect(described_class.new(create :user, approvals: []).total_credits).to eq(0)
      expect(described_class.new(create :user, approvals: [subject1.course.id]).total_credits).to eq(10)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id, subject2.course.id]).total_credits).to eq(10)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id, subject2.exam.id]).total_credits).to eq(21)
      expect(described_class.new(create :user,
                                        approvals: [subject1.course.id, subject2.exam.id,
                                                    subject3.course.id]).total_credits).to eq(33)
    end

    it 'calculates credits only from subjects in the user degree plan' do
      degree1 = create :degree
      degree_plan1 = create :degree_plan, degree: degree1
      degree2 = create :degree
      degree_plan2 = create :degree_plan, degree: degree2

      group1 = create :subject_group, degree_plan: degree_plan1
      group2 = create :subject_group, degree_plan: degree_plan2

      subject1 = create :subject, credits: 10, group: group1, degree_plan: degree_plan1
      subject2 = create :subject, credits: 15, group: group2, degree_plan: degree_plan2
      subject3 = create :subject, credits: 20, group: group1, degree_plan: degree_plan1

      user = create :user, degree_plan: degree_plan1,
                           approvals: [subject1.course.id, subject2.course.id, subject3.course.id]
      student = described_class.new(user)

      expect(student.total_credits).to eq(30)
    end
  end

  describe '#met?' do
    it 'returns true if prerequisite met' do
      subject1 = create :subject, :with_exam
      prereq = create(:subject_prerequisite, approvable: subject1.exam, approvable_needed: subject1.course)

      expect(described_class.new(create :user, approvals: []).met?(prereq)).to be false
      expect(described_class.new(create :user, approvals: [subject1.course.id]).met?(prereq)).to be true
    end
  end

  describe '#group_credits_met?' do
    it 'returns true if group credits met' do
      group = create :subject_group, credits_needed: 10
      subject1 = create :subject, credits: 5, group: group
      subject2 = create :subject, credits: 5, group: group
      user = create :user, approvals: [subject1.course.id]

      expect(described_class.new(user).group_credits_met?(group)).to be false
      user.approvals = [subject1.course.id, subject2.course.id]
      expect(described_class.new(user).group_credits_met?(group)).to be true
    end
  end

  describe '#groups_credits_met?' do
    it 'checks only groups from the user degree plan' do
      degree1 = create :degree
      degree_plan1 = create :degree_plan, degree: degree1
      degree2 = create :degree
      degree_plan2 = create :degree_plan, degree: degree2

      group1 = create :subject_group, degree_plan: degree_plan1, credits_needed: 10
      group2 = create :subject_group, degree_plan: degree_plan1, credits_needed: 10
      group3 = create :subject_group, degree_plan: degree_plan2, credits_needed: 10

      subject1 = create :subject, credits: 10, group: group1, degree_plan: degree_plan1
      subject2 = create :subject, credits: 10, group: group2, degree_plan: degree_plan1
      create :subject, credits: 10, group: group3, degree_plan: degree_plan2

      user = create :user, degree_plan: degree_plan1, approvals: [subject1.course.id, subject2.course.id]
      student = described_class.new(user)

      expect(student.groups_credits_met?).to be true

      user.approvals = [subject1.course.id]
      expect(described_class.new(user).groups_credits_met?).to be false
    end
  end

  describe '#graduated?' do
    it 'returns true if total credits >= 450 and all groups credits met' do
      group = create :subject_group, credits_needed: 10
      subject1 = create :subject, credits: 440, group: group
      subject2 = create :subject, credits: 10, group: group
      user = create :user, approvals: []

      expect(described_class.new(user)).not_to be_graduated
      user.approvals = [subject1.course.id]
      expect(described_class.new(user)).not_to be_graduated
      user.approvals = [subject1.course.id, subject2.course.id]
      expect(described_class.new(user)).to be_graduated
    end
  end

  describe '#force_add_subject' do
    it 'adds both course and exam ids to approvals' do
      subject = create :subject, :with_exam
      user = create :user, approvals: []
      student = described_class.new(user)

      student.force_add_subject(subject)
      expect(user.reload.approvals).to contain_exactly(subject.course.id, subject.exam.id)
    end

    it 'adds only course id when subject has no exam' do
      subject = create :subject
      user = create :user, approvals: []
      student = described_class.new(user)

      student.force_add_subject(subject)
      expect(user.reload.approvals).to contain_exactly(subject.course.id)
    end

    it 'adds ids even if they already exist' do
      subject = create :subject, :with_exam
      user = create :user, approvals: [subject.course.id]
      student = described_class.new(user)

      student.force_add_subject(subject)
      expect(user.reload.approvals).to contain_exactly(subject.course.id, subject.exam.id)
    end
  end

  describe '#degree_plan' do
    let(:degree_plan) { create :degree_plan }
    let(:user) { create :user, degree_plan: }
    let(:student) { described_class.new(user) }

    it 'delegates #degree_plan to user' do
      expect(student.degree_plan).to eq(user.degree_plan)
    end
  end

  describe '#banner_viewed?' do
    let(:user) { create :user }
    let(:student) { described_class.new(user) }

    it 'delegates to user for welcome banner' do
      expect(user).to receive(:welcome_banner_viewed)
      student.banner_viewed?('welcome')
    end

    it 'delegates to user for planner banner' do
      expect(user).to receive(:planner_banner_viewed)
      student.banner_viewed?('planner')
    end

    it 'raises error if banner type is invalid' do
      expect { student.banner_viewed?('invalid') }.to raise_error(NoMethodError)
    end
  end

  describe '#mark_banner_as_viewed!' do
    let(:user) { create :user }
    let(:student) { described_class.new(user) }

    it 'delegates to user for welcome banner' do
      expect { student.mark_banner_as_viewed!('welcome') }.to change(user, :welcome_banner_viewed).from(false).to(true)
    end

    it 'delegates to user for planner banner' do
      expect { student.mark_banner_as_viewed!('planner') }.to change(user, :planner_banner_viewed).from(false).to(true)
    end

    it 'raises error if banner type is invalid' do
      expect { student.mark_banner_as_viewed!('invalid') }.to raise_error(NoMethodError)
    end
  end

  describe "#approved_subjects" do
    let(:user) { create :user }
    let(:student) { described_class.new(user) }

    it 'returns approved subjects for the user' do
      subject1 = create(:subject, :with_exam)
      subject2 = create(:subject, :with_exam)
      user.approvals = [subject1.course.id, subject2.exam.id]

      expect(student.approved_subjects).to contain_exactly(subject2)
    end

    it 'returns only approved subjects from the user degree plan' do
      degree1 = create :degree
      degree_plan1 = create :degree_plan, degree: degree1
      degree2 = create :degree
      degree_plan2 = create :degree_plan, degree: degree2

      group1 = create :subject_group, degree_plan: degree_plan1
      group2 = create :subject_group, degree_plan: degree_plan2

      subject1 = create(:subject, :with_exam, group: group1, degree_plan: degree_plan1)
      subject2 = create(:subject, :with_exam, group: group2, degree_plan: degree_plan2)

      user = create :user, degree_plan: degree_plan1, approvals: [subject1.exam.id, subject2.exam.id]
      student = described_class.new(user)

      expect(student.approved_subjects).to contain_exactly(subject1)
    end
  end
end
