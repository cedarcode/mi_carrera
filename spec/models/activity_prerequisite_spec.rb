require 'rails_helper'

RSpec.describe ActivityPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:approvable_needed).class_name('Approvable') }
  end

  describe '#met?' do
    context 'when the approvable needed is available' do
      it 'returns true' do
        subject_needed = create :subject, :with_exam
        allow(subject_needed.exam).to receive(:available?).and_return(true)
        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([])).to be_truthy
      end
    end

    context 'when the approvable needed is not available' do
      it 'returns false' do
        subject_needed = create :subject, :with_exam
        allow(subject_needed.exam).to receive(:available?).and_return(false)
        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([])).to be_falsey
      end
    end
  end
end
