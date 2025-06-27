require 'rails_helper'

RSpec.describe PreloadedApprovablesFetcher do
  before do
    described_class.instance_variable_set(:@data, nil)
  end

  describe '#fetch' do
    it 'fetches and preloads approvables grouped by their subject' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      preloaded_approvables = described_class.new.fetch

      expect(preloaded_approvables.count).to eq(2)
      expect(preloaded_approvables[s1.id]).to be_present
      expect(preloaded_approvables[s2.id]).to be_present

      expect(preloaded_approvables[s1.id][:course]).to be_present
      expect(preloaded_approvables[s1.id][:exam]).to be_present
      expect(preloaded_approvables[s2.id][:course]).to be_present
      expect(preloaded_approvables[s2.id][:exam]).to be_nil

      c1 = preloaded_approvables[s1.id][:course]
      ex1 = preloaded_approvables[s1.id][:exam]
      c2 = preloaded_approvables[s2.id][:course]

      # check all prerequisite trees are preloaded
      expect(c1.association(:prerequisite_tree).loaded?).to be_truthy
      expect(ex1.association(:prerequisite_tree).loaded?).to be_truthy
      expect(c2.association(:prerequisite_tree).loaded?).to be_truthy

      expect(c1.prerequisite_tree).to be_nil
      expect(ex1.prerequisite_tree).to be_nil

      expect(c2.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(c2.prerequisite_tree.association(:approvable_needed).loaded?).to be_truthy
      expect(c2.prerequisite_tree.approvable_needed).to eq(s1.course)
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
      expect(first_call[s1.id]).to be_present

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
      expect(first_call[s1.id]).to be_present

      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s2.course)

      expect(first_call[s2.id]).to be_nil

      described_class.reload!

      second_call = described_class.data

      expect(second_call[s1.id]).to be_present
      expect(second_call[s2.id]).to be_present
    end
  end
end
