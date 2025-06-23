require 'rails_helper'

RSpec.describe TreePreloader do
  describe '#preload' do
    it 'maintains preloaded subjects after being destroyed' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      subjects = described_class.new(Subject.all).preload.sort_by(&:name)

      Prerequisite.destroy_all
      Approvable.destroy_all
      Subject.destroy_all

      # check all entities are destroyed
      expect(Subject.count).to eq(0)
      expect(Approvable.count).to eq(0)
      expect(Prerequisite.count).to eq(0)

      # subjects are maintained
      expect(subjects.count).to eq(2)
      expect(subjects.first.name).to eq('s1')
      expect(subjects.last.name).to eq('s2')

      # approvables are maintained
      expect(subjects.map(&:course).count).to eq(2)
      expect(subjects.map(&:exam).count).to eq(2)

      # prerequisites are maintained
      expect(subjects.last.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects.last.course.prerequisite_tree.approvable_needed).to eq(s1.course)
    end

    it 'filters subjects by name' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      subjects = described_class.new(Subject.where(id: s2)).preload

      expect(subjects.count).to eq(1)
      expect(subjects.first.name).to eq('s2')

      expect(subjects.first.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects.first.course.prerequisite_tree.approvable_needed).to eq(s1.course)

      subjects = described_class.new(Subject.where(name: 'does_not_exist')).preload

      expect(subjects.count).to eq(0)

      subjects = described_class.new(Subject.all).preload

      expect(subjects.count).to eq(2)
      expect(subjects.first.name).to eq('s1')
      expect(subjects.last.name).to eq('s2')

      expect(subjects.last.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects.last.course.prerequisite_tree.approvable_needed).to eq(s1.course)
    end
  end

  describe '#clear_cache' do
    it 'calls Rails.cache.delete with the correct key' do
      create(:subject, :with_exam, name: 's1')

      expect(Rails.cache).to receive(:delete).with(TreePreloader::SUBJECTS_KEY)

      described_class.new(Subject.all).clear_cache
    end
  end
end
