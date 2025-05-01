require 'rails_helper'

RSpec.describe CreditsPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:subject_group).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:credits_needed) }
  end

  describe '#met?' do
    context 'when credits >= needed' do
      it 'returns true' do
        prerequisite = build :credits_prerequisite, credits_needed: 2
        s_2_credits = create :subject, credits: 2
        s_3_credits = create :subject, credits: 3

        expect(prerequisite.met?([s_2_credits.course.id])).to be true
        expect(prerequisite.met?([s_3_credits.course.id])).to be true
      end
    end

    context 'when credits < needed' do
      it 'returns false' do
        prerequisite = build :credits_prerequisite, credits_needed: 2
        s_1_credits = create :subject, credits: 1

        expect(prerequisite.met?([s_1_credits.course.id])).to be false
      end
    end

    context 'with subject_group and other subjects' do
      context 'when credits >= needed' do
        it 'returns true' do
          group = create :subject_group
          s1_with_group = create :subject, credits: 2, group: group
          s2_with_group = create :subject, credits: 3, group: group
          s3_without_group = create :subject, credits: 3
          prerequisite = build :credits_prerequisite, credits_needed: 5, subject_group: group

          expect(prerequisite.met?([s1_with_group.course.id, s2_with_group.course.id,
                                    s3_without_group.course.id])).to be true
        end
      end

      context 'when credits < needed' do
        it 'returns false' do
          group = create :subject_group
          s1_with_group = create :subject, credits: 2, group: group
          s3_without_group = create :subject, credits: 3
          prerequisite = build :credits_prerequisite, credits_needed: 5, subject_group: group

          expect(prerequisite.met?([s1_with_group.course.id, s3_without_group.course.id])).to be false
        end
      end
    end
  end
end
