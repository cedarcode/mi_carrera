require 'rails_helper'

RSpec.describe ActivityPrerequisite, type: :model do
  describe '#met?' do
    context 'when the approvable needed is available' do
      it 'returns true' do
        subject_needed = create :subject, :with_exam
        create :credits_prerequisite, approvable: subject_needed.exam, credits_needed: 5

        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([create(:subject, credits: 5).course])).to be_truthy
      end
    end

    context 'when the approvable needed is not available' do
      it 'returns false' do
        subject_needed = create :subject, :with_exam
        create :credits_prerequisite, approvable: subject_needed.exam, credits_needed: 5

        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([])).to be_falsey
      end
    end
  end
end
