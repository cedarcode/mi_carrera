require 'rails_helper'

RSpec.describe PreloadedSubjectsFetcher do
  before do
    described_class.instance_variable_set(:@data, nil)
  end

  describe '#fetch' do
    it 'fetches and preloads subjects with their courses and exams' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      subjects = described_class.new.fetch

      expect(subjects.count).to eq(2)
      expect(subjects[s1.id].name).to eq('s1')
      expect(subjects[s2.id].name).to eq('s2')

      expect(subjects[s1.id].association(:course).loaded?).to be_truthy
      expect(subjects[s1.id].course).to be_present
      expect(subjects[s1.id].course.association(:prerequisite_tree).loaded?).to be_truthy
      expect(subjects[s1.id].course.prerequisite_tree).to be_nil

      expect(subjects[s2.id].association(:course).loaded?).to be_truthy
      expect(subjects[s1.id].course).to be_present
      expect(subjects[s2.id].course.association(:prerequisite_tree).loaded?).to be_truthy
      expect(subjects[s2.id].course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects[s2.id].course.prerequisite_tree.association(:approvable_needed).loaded?).to be_truthy
      expect(subjects[s2.id].course.prerequisite_tree.approvable_needed).to eq(s1.course)

      expect(subjects[s1.id].exam).to be_present
      expect(subjects[s2.id].exam).to be_present
    end

    it 'returns an empty hash when no subjects are found' do
      subjects = described_class.new.fetch

      expect(subjects).to eq({})
    end
  end

  describe '.data' do
    it 'returns an empty hash when no subjects are found' do
      expect(described_class.data).to eq({})
    end

    it 'returns cached data after the first call' do
      s1 = create(:subject, :with_exam, name: 's1')
      create(:subject_prerequisite, approvable: s1.course, approvable_needed: s1.course)

      first_call = described_class.data
      expect(first_call[s1.id].name).to eq('s1')

      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s2.course)

      second_call = described_class.data

      expect(second_call).to eq(first_call)
      expect(second_call[s2.id]).to be_nil
    end
  end

  describe '.reload!' do
    it 'reloads the cached data' do
      s1 = create(:subject, :with_exam, name: 's1')
      create(:subject_prerequisite, approvable: s1.course, approvable_needed: s1.course)

      first_call = described_class.data
      expect(first_call[s1.id].name).to eq('s1')

      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s2.course)

      expect(first_call[s2.id]).to be_nil

      described_class.reload!

      second_call = described_class.data

      expect(second_call[s1.id].name).to eq('s1')
      expect(second_call[s2.id].name).to eq('s2')
    end
  end
end
