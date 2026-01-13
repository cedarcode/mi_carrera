require 'rails_helper'

RSpec.describe TreePreloader do
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

    it 'preloads subjects with their approvables' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      preloaded_subjects = described_class.preload(Subject.all)

      preloaded_s1 = preloaded_subjects.find { |s| s.id == s1.id }
      preloaded_s2 = preloaded_subjects.find { |s| s.id == s2.id }

      expect(preloaded_subjects.count).to eq(2)
      expect(preloaded_s1).to be_present
      expect(preloaded_s2).to be_present

      expect(preloaded_s1.course).to be_present
      expect(preloaded_s1.exam).to be_present
      expect(preloaded_s2.course).to be_present
      expect(preloaded_s2.exam).to be_nil

      # check all prerequisite trees are preloaded
      expect(preloaded_s1.course.association(:prerequisite_tree).loaded?).to be_truthy
      expect(preloaded_s1.exam.association(:prerequisite_tree).loaded?).to be_truthy
      expect(preloaded_s2.course.association(:prerequisite_tree).loaded?).to be_truthy

      expect(preloaded_s1.course.prerequisite_tree).to be_nil
      expect(preloaded_s1.exam.prerequisite_tree).to be_nil

      expect(preloaded_s2.course.prerequisite_tree).to be_a(SubjectPrerequisite)
      expect(preloaded_s2.course.prerequisite_tree.association(:approvable_needed).loaded?).to be_truthy
      expect(preloaded_s2.course.prerequisite_tree.approvable_needed).to eq(s1.course)
    end

    it 'uses cached data for preloading' do
      s1 = create(:subject, :with_exam, name: 's1')
      s2 = create(:subject, name: 's2')
      create(:subject_prerequisite, approvable: s2.course, approvable_needed: s1.course)

      first_call_results = described_class.preload(Subject.all)

      expect(first_call_results.count).to eq(2)
      expect(first_call_results.first.name).to eq('s1')
      expect(first_call_results.last.name).to eq('s2')

      s3 = create(:subject, :with_exam, name: 's3')

      second_call_results = described_class.preload(Subject.all)

      expect(second_call_results.count).to eq(3)
      preloaded_s1 = second_call_results.find { |s| s.id == s1.id }
      preloaded_s2 = second_call_results.find { |s| s.id == s2.id }
      preloaded_s3 = second_call_results.find { |s| s.id == s3.id }

      # check that s3 does not have any approvables preloaded
      expect(preloaded_s1.association(:course).loaded?).to be_truthy
      expect(preloaded_s1.association(:exam).loaded?).to be_truthy
      expect(preloaded_s2.association(:course).loaded?).to be_truthy
      expect(preloaded_s2.association(:exam).loaded?).to be_truthy
      expect(preloaded_s3.association(:course).loaded?).to be_falsey
      expect(preloaded_s3.association(:exam).loaded?).to be_falsey
    end
  end

  describe '.break_cache!' do
    it 'reloads the cached data' do
      s1 = create(:subject, :with_exam, name: 's1')
      create(:subject_prerequisite, approvable: s1.course, approvable_needed: s1.course)

      first_call_results = described_class.preload(Subject.all)

      expect(first_call_results.count).to eq(1)
      preloaded_s1 = first_call_results.first

      expect(preloaded_s1.association(:course).loaded?).to be_truthy
      expect(preloaded_s1.association(:exam).loaded?).to be_truthy

      s2 = create(:subject, :with_exam, name: 's2')

      second_call_results = described_class.preload(Subject.all)
      expect(second_call_results.count).to eq(2)

      preloaded_s1 = second_call_results.find { |s| s.id == s1.id }
      preloaded_s2 = second_call_results.find { |s| s.id == s2.id }

      expect(preloaded_s1.association(:course).loaded?).to be_truthy
      expect(preloaded_s1.association(:exam).loaded?).to be_truthy
      expect(preloaded_s2.association(:course).loaded?).to be_falsey
      expect(preloaded_s2.association(:exam).loaded?).to be_falsey

      described_class.break_cache!

      third_call = described_class.preload(Subject.all)

      expect(third_call.count).to eq(2)
      preloaded_s1 = third_call.find { |s| s.id == s1.id }
      preloaded_s2 = third_call.find { |s| s.id == s2.id }

      expect(preloaded_s1.association(:course).loaded?).to be_truthy
      expect(preloaded_s1.association(:exam).loaded?).to be_truthy
      expect(preloaded_s2.association(:course).loaded?).to be_truthy
      expect(preloaded_s2.association(:exam).loaded?).to be_truthy
    end
  end
end
