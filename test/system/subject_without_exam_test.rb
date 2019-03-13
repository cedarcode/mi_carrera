require "application_system_test_case"

class SubjectWihoutExamTest < ApplicationSystemTestCase
  setup do
    maths = SubjectsGroup.create!(name: "Matemáticas")
    @subject = create_subject("Taller", credits: 5, exam: false, group_id: maths.id)
  end

  test "approved course earns credits" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: false

    click_on "arrow_back"

    assert_text "5 créditos"
  end
end
