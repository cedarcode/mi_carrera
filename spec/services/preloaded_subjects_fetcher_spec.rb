require 'rails_helper'

RSpec.describe PreloadedSubjectsFetcher do
  describe '#call' do
    it 'fetches and preloads subjects with their courses and exams' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      subjects = described_class.call

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
      subjects = described_class.call

      expect(subjects).to eq({})
    end
  end
end
