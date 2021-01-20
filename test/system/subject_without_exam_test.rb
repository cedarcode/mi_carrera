require "application_system_test_case"

class SubjectWihoutExamTest < ApplicationSystemTestCase
  setup do
    visit root_path
    click_on "¡Probar la app!"

    @subject = create_subject(name: "Taller", credits: 5, exam: false)
  end

  test "approved course earns credits" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: :all

    click_on "arrow_back"

    assert_text "5 créditos"
  end
end
