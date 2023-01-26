require 'test_helper'
# require 'tree_preloader'

class TreePreloaderTest < ActiveSupport::TestCase

  test "preloaded subjects should be mantained after being destroyed" do
    s1 = create_subject(name: "s1", exam: true)
    s2 = create_subject(name: "s2", exam: true)
    SubjectPrerequisite.create!(approvable_id: s2.course.id, approvable_needed_id: s1.course.id)

    subjects = ::TreePreloader.new.preload.sort_by(&:name)

    Subject.destroy_all
    Approvable.destroy_all
    Prerequisite.destroy_all

    # subjects are mantained
    assert_equal 2, subjects.count
    assert_equal "s1", subjects.first.name
    assert_equal "s2", subjects.last.name

    # approvables are mantained
    assert_equal 2, subjects.map(&:course).count
    assert_equal 2, subjects.map(&:exam).count

    # prerequisites are mantained
    assert_equal 1, subjects.last.course.prerequisite_tree.operands_prerequisites.count
    assert_equal s1.course, subjects.last.course.prerequisite_tree.operands_prerequisites.first.approvable_needed

  end
end
