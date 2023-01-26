require 'test_helper'

class TreePreloaderTest < ActiveSupport::TestCase
  test "preloaded subjects should be mantained after being destroyed" do
    s1 = create_subject(name: "s1", exam: true)
    s2 = create_subject(name: "s2", exam: true)
    SubjectPrerequisite.create!(approvable_id: s2.course.id, approvable_needed_id: s1.course.id)

    subjects = TreePreloader.new.preload.sort_by(&:name)

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
end
