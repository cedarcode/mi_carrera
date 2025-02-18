module PlannedSubjectsTestHelper
  def assert_approved_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_text "done"
    end
  end

  def assert_blocked_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_text "lock"
    end
  end

  def assert_available_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_no_text "done"
      expect(page).to have_no_text "lock"
    end
  end

  def within_planned_subjects(&block)
    within(:xpath, "//div[h3[contains(text(), 'Materias planeadas')]]/following-sibling::*[1]", &block)
  end

  def within_not_planned_approved_subjects(&block)
    within(:xpath, "//h3[contains(text(), 'Materias aprobadas sin semestre asignado')]/following-sibling::*[1]", &block)
  end

  private

  def within_subject_row(subject_name, &block)
    within(:xpath, "//*[contains(@class, 'mdc-deprecated-list-item')][*[contains(text(), '#{subject_name}')]]", &block)
  end
end
