require 'rails_helper'

RSpec.describe Transcript::AcademicEntry, type: :lib do
  describe 'academic entry' do
    let(:entry) { build(:academic_entry) }
    let(:failed_entry) { build(:academic_entry, :failed) }

    it 'has a name' do
      expect(entry.name).to eq('Test Subject')
    end

    it 'has a number of credits' do
      expect(entry.credits).to eq('10')
    end

    it 'has a number of failures' do
      expect(entry.number_of_failures).to eq('0')
    end

    it 'has a date of completion' do
      expect(entry.date_of_completion).to eq('20/02/2024')
    end

    it 'has a grade' do
      expect(entry.grade).to eq('Aceptable')
    end

    it 'is approved if the grade is not ***' do
      expect(entry).to be_approved
    end

    it 'is not approved if the grade is ***' do
      expect(failed_entry).not_to be_approved
    end
  end

  describe '#save_to_user' do
    let(:student) { build(:cookie_student) }

    it 'returns false when subject name is blank' do
      entry = described_class.new(name: nil, credits: 5)
      expect(entry.save_to_user(student)).to be false
    end

    it 'returns false when subject is not found' do
      entry = described_class.new(name: 'Non-existent Subject', credits: 5)
      expect(entry.save_to_user(student)).to be false
    end

    it 'adds subject to student when exact match is found' do
      subject = create(:subject, name: 'Mathematics', credits: 5)
      entry = described_class.new(name: 'Mathematics', credits: 5)

      result = entry.save_to_user(student)

      expect(result).to eq(subject)
      expect(student.approved?(subject)).to be true
    end

    it 'adds subject to student when case-insensitive match is found' do
      subject = create(:subject, name: 'Mathematics', credits: 5)
      entry = described_class.new(name: 'mathematics', credits: 5)

      result = entry.save_to_user(student)

      expect(result).to eq(subject)
      expect(student.approved?(subject)).to be true
    end

    it 'adds active subject when multiple matches exist' do
      inactive_subject = create(:subject, :inactive, name: 'Mathematics', credits: 5)
      active_subject = create(:subject, name: 'Mathematics', credits: 5)
      entry = described_class.new(name: 'Mathematics', credits: 5)

      result = entry.save_to_user(student)

      expect(result).to eq(active_subject)
      expect(student.approved?(active_subject)).to be true
      expect(student.approved?(inactive_subject)).to be false
    end

    it 'adds subject with matching credits' do
      subject1 = create(:subject, name: 'Mathematics', credits: 5)
      subject2 = create(:subject, name: 'Mathematics', credits: 10)
      entry = described_class.new(name: 'Mathematics', credits: 5)

      result = entry.save_to_user(student)

      expect(result).to eq(subject1)
      expect(student.approved?(subject1)).to be true
      expect(student.approved?(subject2)).to be false
    end
  end
end
