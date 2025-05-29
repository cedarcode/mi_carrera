module PlannedSubjectsTestHelper
  def assert_approved_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("img[src*='check']")
    end
  end

  def assert_blocked_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("img[src*='lock']")
    end
  end

  def assert_available_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_no_selector("img[src*='check']")
      expect(page).to have_no_selector("img[src*='lock']")
    end
  end

  def assert_planned_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("img[src*='remove_circle']")
    end
  end

  def assert_not_planned_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector("img[src*='add_circle']")
      expect(page).to have_selector("select", text: 'Sem. 1')
    end
  end

  def assert_subject_in_selector(subject_name_with_code)
    expect(page).to have_select('subject_plan_subject_id', with_options: [subject_name_with_code])
  end

  def assert_subject_not_in_selector(subject_name_with_code)
    expect(page).to have_no_select('subject_plan_subject_id', with_options: [subject_name_with_code])
  end

  def within_planned_subjects(&block)
    within(:xpath, "//div[h3[contains(text(), 'Materias planeadas')]]/following-sibling::*[1]", &block)
  end

  def within_not_planned_approved_subjects(&block)
    within(:xpath, "//h3[contains(text(), 'Materias aprobadas sin semestre asignado')]/following-sibling::*[1]", &block)
  end

  def within_not_planned_subjects(&block)
    within("#new-planned-subject", &block)
  end

  private

  def within_subject_row(subject_name, &block)
    within(".flex.items-center", text: subject_name, &block)
  end
end
