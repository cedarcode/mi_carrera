require 'rails_helper'

RSpec.describe TreePreloader do
  before do
    described_class.break_cache!
  end

  describe '.preload' do
    it 'maintains preloaded subjects after being destroyed' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      subjects = described_class.preload(Subject.all).sort_by(&:name)

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

      subjects = described_class.preload(Subject.where(id: s2))

      expect(subjects.count).to eq(1)
      expect(subjects.first.name).to eq('s2')

      expect(subjects.first.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects.first.course.prerequisite_tree.approvable_needed).to eq(s1.course)

      subjects = described_class.preload(Subject.where(name: 'does_not_exist'))

      expect(subjects.count).to eq(0)

      subjects = described_class.preload(Subject.all)

      expect(subjects.count).to eq(2)
      expect(subjects.first.name).to eq('s1')
      expect(subjects.last.name).to eq('s2')

      expect(subjects.last.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(subjects.last.course.prerequisite_tree.approvable_needed).to eq(s1.course)
    end
  end

  describe '.preloaded_approvables' do
    it 'returns an empty hash when no subjects are found' do
      expect(described_class.preloaded_approvables).to eq({})
    end

    it 'returns cached data after the first call' do
      s1 = create(:subject, :with_exam, name: 's1')
      create(:subject_prerequisite, approvable: s1.course, approvable_needed: s1.course)

      first_call = described_class.preloaded_approvables
      expect(first_call[s1.id]).to be_present

      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s2.course)

      second_call = described_class.preloaded_approvables

      expect(second_call).to eq(first_call)
      expect(second_call[s2.id]).to be_nil
    end

    it 'fetches and preloads approvables grouped by their subject' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      preloaded_approvables = described_class.preloaded_approvables

      expect(preloaded_approvables.count).to eq(2)
      expect(preloaded_approvables[s1.id]).to be_present
      expect(preloaded_approvables[s2.id]).to be_present

      s1_approvables = preloaded_approvables[s1.id]
      s2_approvables = preloaded_approvables[s2.id]

      c1 = s1_approvables.find(&:is_course?)
      ex1 = s1_approvables.find(&:is_exam?)
      c2 = s2_approvables.find(&:is_course?)
      ex2 = s2_approvables.find(&:is_exam?)

      expect(c1).to be_present
      expect(ex1).to be_present
      expect(c2).to be_present
      expect(ex2).to be_nil

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
  end

  describe '.break_cache!' do
    it 'reloads the cached data' do
      s1 = create(:subject, :with_exam, name: 's1')
      create(:subject_prerequisite, approvable: s1.course, approvable_needed: s1.course)

      first_call = described_class.preloaded_approvables
      expect(first_call[s1.id]).to be_present

      s2 = create(:subject, :with_exam, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s2.course)

      expect(first_call[s2.id]).to be_nil

      described_class.break_cache!

      second_call = described_class.preloaded_approvables

      expect(second_call[s1.id]).to be_present
      expect(second_call[s2.id]).to be_present
    end
  end
end
