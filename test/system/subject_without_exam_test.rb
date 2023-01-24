require "application_system_test_case"

class SubjectWihoutExamTest < ApplicationSystemTestCase
  setup do
    @subject = create_subject(name: "Taller", credits: 5, exam: false)
  end

  test "approved course earns credits" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: :all

    wait_for_async_request

    click_on "Student"

    assert_text "5 créditos"
  end
end
