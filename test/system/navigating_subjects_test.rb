require "application_system_test_case"

class NavigatingSubjectsTest < ApplicationSystemTestCase
  setup do
    @subject1 = create_subject(name: "Subject 1", credits: 1, exam: false)
    @subject2 = create_subject(name: "Subject 2", credits: 2, exam: true)
    @subject3 = create_subject(name: "Subject 3", credits: 3, exam: false)

    SubjectPrerequisite.create!(approvable_id: @subject2.course.id, approvable_needed_id: @subject1.course.id)
    SubjectPrerequisite.create!(approvable_id: @subject3.course.id, approvable_needed_id: @subject2.exam.id)
  end

  test 'navigating subjects' do
    visit all_subjects_path
    # go to subject 3, assert that subject 2 exam is required and go to subject 2 through the link
    click_on @subject3.name
    assert_text @subject3.name
    click_on @subject2.name + ' (examen)'

    # assert that subject 1 course is required and go to subject 1 through the link
    assert_text @subject2.name
    click_on @subject1.name + ' (curso)'
    assert_text @subject1.name
  end
end
