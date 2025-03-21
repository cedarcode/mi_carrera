require 'test_helper'

class TreePreloaderTest < ActiveSupport::TestCase
  test "preloaded subjects should be mantained after being destroyed" do
    s1 = create :subject, :with_exam, name: "s1"
    s2 = create :subject, :with_exam, name: "s2"
    create :subject_prerequisite, approvable: s2.course, approvable_needed: s1.course

    subjects = TreePreloader.new.preload_subjects.sort_by(&:name)

    Subject.destroy_all
    Approvable.destroy_all
    Prerequisite.destroy_all

    # check all entities are destroyed
    assert_equal 0, Subject.count
    assert_equal 0, Approvable.count
    assert_equal 0, Prerequisite.count

    # subjects are mantained
    assert_equal 2, subjects.count
    assert_equal "s1", subjects.first.name
    assert_equal "s2", subjects.last.name

    # approvables are mantained
    assert_equal 2, subjects.map(&:course).count
    assert_equal 2, subjects.map(&:exam).count

    # prerequisites are mantained
    assert_equal SubjectPrerequisite, subjects.last.course.prerequisite_tree.class
    assert_equal s1.course, subjects.last.course.prerequisite_tree.approvable_needed
  end

  test "subjects should be filtered by name" do
    s1 = create :subject, :with_exam, name: "s1"
    s2 = create :subject, :with_exam, name: "s2"
    create :subject_prerequisite, approvable: s2.course, approvable_needed: s1.course

    subjects = TreePreloader.new.preload_subjects(Subject.where(id: s2))

    assert_equal 1, subjects.count
    assert_equal "s2", subjects.first.name

    assert_equal SubjectPrerequisite, subjects.first.course.prerequisite_tree.class
    assert_equal s1.course, subjects.first.course.prerequisite_tree.approvable_needed

    subjects = TreePreloader.new.preload_subjects(Subject.where(name: 'does_not_exist'))

    assert_equal 0, subjects.count

    subjects = TreePreloader.new.preload_subjects

    assert_equal 2, subjects.count
    assert_equal "s1", subjects.first.name
    assert_equal "s2", subjects.last.name

    assert_equal SubjectPrerequisite, subjects.last.course.prerequisite_tree.class
    assert_equal s1.course, subjects.last.course.prerequisite_tree.approvable_needed
  end

  test "#preload_subjects keeps the order of the subjects" do
    create :subject, :with_exam, name: "a"
    create :subject, :with_exam, name: "b"
    create :subject, :with_exam, name: "c"

    subjects = Subject.all.order(name: :desc)
    preloaded_subjects = TreePreloader.new.preload_subjects(subjects)

    assert_equal ["c", "b", "a"], subjects.map(&:name)
    assert_equal ["c", "b", "a"], preloaded_subjects.map(&:name)
  end

  test "#preload_subjects returns all subjects without order by default" do
    create :subject, :with_exam, name: "z", category: "second_semester"
    create :subject, :with_exam, name: "a", category: "second_semester"
    create :subject, :with_exam, name: "c", category: "first_semester"

    preloaded_subjects = TreePreloader.new.preload_subjects

    subject_names = preloaded_subjects.map(&:name)

    assert_includes subject_names, "z"
    assert_includes subject_names, "a"
    assert_includes subject_names, "c"
  end

  test "#preload_subjects supports array of subjects" do
    s1 = create :subject, :with_exam, name: "b"
    s2 = create :subject, :with_exam, name: "a"
    create :subject, :with_exam, name: "c"

    subjects = TreePreloader.new.preload_subjects([s1, s2])

    assert_equal 2, subjects.size

    assert_equal ["b", "a"], subjects.map(&:name)
    subject_b = subjects.first

    assert subject_b.association(:course).loaded?
    assert subject_b.association(:exam).loaded?
    assert subject_b.course.association(:prerequisite_tree).loaded?
    assert subject_b.exam.association(:prerequisite_tree).loaded?
  end
end
