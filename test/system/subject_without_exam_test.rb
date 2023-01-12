require "application_system_test_case"

class SubjectWihoutExamTest < ApplicationSystemTestCase
  setup do
    @subject = create_subject(name: "Taller", credits: 5, exam: false)
  end

  test "approved course earns credits" do
    visit subject_path(@subject)

    check "Curso aprobado?", visible: :all

    click_actions_menu
    within_actions_menu do
      click_on 'Inicio'
    end

    assert_text "5 créditos"
  end
end
