require 'test_helper'

class TreePreloaderTest < ActiveSupport::TestCase
  test "preloaded subjects should be mantained after being destroyed" do
    s1 = create :subject, :with_exam, name: "s1"
    s2 = create :subject, :with_exam, name: "s2"
    create :subject_prerequisite, approvable: s2.course, approvable_needed: s1.course

    subjects = TreePreloader.new(Subject).preload.sort_by(&:name)

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

    subjects = TreePreloader.new(Subject.where(id: s2)).preload

    assert_equal 1, subjects.count
    assert_equal "s2", subjects.first.name

    assert_equal SubjectPrerequisite, subjects.first.course.prerequisite_tree.class
    assert_equal s1.course, subjects.first.course.prerequisite_tree.approvable_needed

    subjects = TreePreloader.new(Subject.where(name: 'does_not_exist')).preload

    assert_equal 0, subjects.count

    subjects = TreePreloader.new(Subject).preload

    assert_equal 2, subjects.count
    assert_equal "s1", subjects.first.name
    assert_equal "s2", subjects.last.name

    assert_equal SubjectPrerequisite, subjects.last.course.prerequisite_tree.class
    assert_equal s1.course, subjects.last.course.prerequisite_tree.approvable_needed
  end
end
