require 'test_helper'

class BedelTest < ActiveSupport::TestCase
  setup do
    @subject1 = create_subject(name: "Subject 1", credits: 16, exam: false)
    @subject2 = create_subject(name: "Subject 2", credits: 13, exam: false)

    prerequisite1 = LogicalPrerequisite.create!(approvable_id: @subject2.course.id, logical_operator: "not")
    SubjectPrerequisite.create!(parent_prerequisite: prerequisite1, approvable_needed: @subject1.course)
  end

  test "approve first version" do
    bedel = Bedel.new({})

    assert(bedel.able_to_do?(@subject2.course))

    bedel.add_approval(@subject1.course)
    assert_not(bedel.able_to_do?(@subject2.course))
  end
end
