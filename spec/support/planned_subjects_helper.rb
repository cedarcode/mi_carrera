module PlannedSubjectsHelper
  def assert_approved_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("svg[data-icon='check']")
    end
  end

  def assert_blocked_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("svg[data-icon='lock']")
    end
  end

  def assert_available_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_no_selector("svg[data-icon='check']")
      expect(page).to have_no_selector("svg[data-icon='lock']")
    end
  end

  def assert_planned_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("svg[data-icon='remove-circle']")
    end
  end

  def assert_no_subject(subject_name)
    expect(page).to have_no_selector("li", text: subject_name)
  end

  def assert_subject_with_semester_selector(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("svg[data-icon='add-circle']")
      expect(page).to have_selector("select", text: 'Sem. 1')
    end
  end

  def assert_subject_selector_contains(subject_name_with_code)
    expect(page).to have_select('subject_plan_subject_id', with_options: [subject_name_with_code])
  end

  def assert_subject_not_in_selector(subject_name_with_code)
    expect(page).to have_no_select('subject_plan_subject_id', with_options: [subject_name_with_code])
  end

  def within_planned_subjects(&block)
    within(:xpath, "//div[h3[contains(text(), 'Materias planificadas')]]/following-sibling::*[1]", &block)
  end

  def within_not_planned_approved_subjects(&block)
    within(:xpath, "//h3[contains(text(), 'Materias aprobadas sin semestre asignado')]/following-sibling::*[1]", &block)
  end

  def within_semester_section(semester, &block)
    within(:xpath, "//h3[contains(text(), '#{semester}')]/../..", &block)
  end

  def within_add_subject_section(&block)
    within(:xpath, ".//form[.//select[@name='subject_plan[subject_id]']]", &block)
  end

  private

  def within_subject_row(subject_name, &block)
    within("li", text: subject_name, &block)
  end
end
