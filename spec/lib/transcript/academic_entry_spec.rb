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
end
