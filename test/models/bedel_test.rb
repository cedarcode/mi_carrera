require 'test_helper'

class BedelTest < ActiveSupport::TestCase
  setup do
    # subject 2 cant be approved if subject 1 course is approved
    @subject1 = create_subject(name: "Subject 1", credits: 16, exam: false)
    @subject2 = create_subject(name: "Subject 2", credits: 13, exam: false)

    prerequisite1 = LogicalPrerequisite.create!(approvable_id: @subject2.course.id, logical_operator: "not")
    SubjectPrerequisite.create!(parent_prerequisite: prerequisite1, approvable_needed: @subject1.course)

    # subject with exam
    @subject3 = create_subject(name: "Subject 3", credits: 13, exam: true)
  end

  test "approve first version" do
    bedel = Bedel.new({})
    assert(bedel.able_to_do?(@subject2.course))
    bedel.add_approval(@subject1.course)
    assert_not(bedel.able_to_do?(@subject2.course))
  end

  test '.add_approval subject1 course, when passing user should add subject to users approvals in store and in user.approvals' do
    user = create_user
    bedel = Bedel.new({}, user)
    bedel.add_approval(@subject1.course)

    assert_equal([@subject1.id], user.approvals[:approved_courses])
    assert_equal([@subject1.id], bedel.store[:approved_courses])
  end

  test '.add_approval subject3 exam, when passing user should add subject to users approvals in store and in user.approvals' do
    user = create_user
    bedel = Bedel.new({}, user)
    bedel.add_approval(@subject3.exam)
    assert_equal([@subject3.id], user.approvals[:approved_exams])
    assert_equal([@subject3.id], bedel.store[:approved_exams])
  end

  test '.add_approval subject1 course, when not passing user should add subject to store' do
    bedel = Bedel.new({})
    bedel.add_approval(@subject1.course)
    assert_equal([@subject1.id], bedel.store[:approved_courses])
  end

  test '.add_approval subject3 exam, when not passing user should add subject to store' do
    bedel = Bedel.new({})
    bedel.add_approval(@subject3.exam)
    assert_equal([@subject3.id], bedel.store[:approved_exams])
  end

  test '.remove_approval subject1 course, when passing user should remove subject from users approvals in store and in user.approvals' do
    user = create_user
    bedel = Bedel.new({ approved_courses: [@subject1.id] }, user)

    bedel.remove_approval(@subject1.course)
    assert_equal([], user.approvals[:approved_courses])
    assert_equal([], bedel.store[:approved_courses])
  end

  test '.remove_approval subject3 exam, when passing user should remove subject from users approvals in store and in user.approvals' do
    user = create_user
    bedel = Bedel.new({ approved_exams: [@subject3.id] }, user)

    bedel.remove_approval(@subject3.exam)
    assert_equal([], user.approvals[:approved_exams])
    assert_equal([], bedel.store[:approved_exams])
  end

  test '.remove_approval subject1 course, when not passing user should remove subject from store' do
    bedel = Bedel.new(approved_courses: [@subject1.id])
    bedel.remove_approval(@subject1.course)
    assert_equal([], bedel.store[:approved_courses])
  end

  test '.remove_approval subject3 exam, when not passing user should remove subject from store' do
    bedel = Bedel.new(approved_exams: [@subject3.id])
    bedel.remove_approval(@subject3.exam)
    assert_equal([], bedel.store[:approved_exams])
  end
end
