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

  test "when bedel was instantiated without a user, a session with a course already approved shouldn't be able to approve it again" do
    store = {}
    bedel = Bedel.new(store)

    assert(bedel.able_to_do?(@subject2.course))

    bedel.add_approval(@subject1.course)

    assert_not(bedel.able_to_do?(@subject2.course))
  end

  test "when bedel was instantiated without a user, .add_approval, when receiving a course, should add subject's course to store" do
    store = {}
    bedel = Bedel.new(store)

    bedel.add_approval(@subject1.course)

    assert_equal([@subject1.id], store[:approved_courses])
  end

  test "when bedel was instantiated without a user, .add_approval, when receiving an exam, should add subject's exam to store" do
    store = {}
    bedel = Bedel.new(store)

    bedel.add_approval(@subject3.exam)

    assert_equal([@subject3.id], store[:approved_exams])
  end

  test "when bedel was instantiated without a user, .remove_approval when receiving a course, should remove subject's course from store" do
    store = { approved_courses: [@subject1.id] }
    bedel = Bedel.new(store)

    bedel.remove_approval(@subject1.course)

    assert_equal([], store[:approved_courses])
  end

  test "when bedel was instantiated without a user, .remove_approval when receiving an exam, should remove subject's exam from store" do
    store = { approved_exams: [@subject3.id] }
    bedel = Bedel.new(store)

    bedel.remove_approval(@subject3.exam)

    assert_equal([], store[:approved_exams])
  end

  test "when bedel was instantiated without a user, .able_to_do? when receiving a course that can't approve, should return false" do
    store = { approved_courses: [@subject1.id] }
    bedel = Bedel.new(store)

    assert_not(bedel.able_to_do?(@subject2.course))
  end
  test "when bedel was instantiated with a user, .add_approval, when receiving a course, should add subject's course to store and to user.approvals" do
    user = create_user
    store = {}
    bedel = Bedel.new(store, user)

    bedel.add_approval(@subject1.course)

    assert_equal([@subject1.id], user.approvals[:approved_courses])
    assert_equal([@subject1.id], store[:approved_courses])
  end

  test "when bedel was instantiated with a user, .add_approval, when receiving an exam, should add subject's exam to store and to user.approvals" do
    user = create_user
    store = {}
    bedel = Bedel.new(store, user)

    bedel.add_approval(@subject3.exam)

    assert_equal([@subject3.id], user.approvals[:approved_exams])
    assert_equal([@subject3.id], store[:approved_exams])
  end

  test "when bedel was instantiated with a user, .remove_approval, when receiving a course, should remove subject's course from store and from user.approvals" do
    user = create_user
    store = { approved_courses: [@subject1.id] }
    bedel = Bedel.new(store, user)

    bedel.remove_approval(@subject1.course)

    assert_equal([], user.approvals[:approved_courses])
    assert_equal([], store[:approved_courses])
  end

  test "when bedel was instantiated with a user, .remove_approval, when receiving an exam, should remove subject's exam from store and from user.approvals" do
    user = create_user
    store = { approved_exams: [@subject3.id] }
    bedel = Bedel.new(store, user)

    bedel.remove_approval(@subject3.exam)

    assert_equal([], user.approvals[:approved_exams])
    assert_equal([], store[:approved_exams])
  end
end
