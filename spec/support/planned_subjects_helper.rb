module PlannedSubjectsHelper
  def assert_approved_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector(".material-icons", text: "check")
    end
  end

  def assert_blocked_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector(".material-icons", text: "lock_outline")
    end
  end

  def assert_available_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_no_selector(".material-icons", text: "check")
      expect(page).to have_no_selector(".material-icons", text: "lock_outline")
    end
  end

  def assert_planned_subject(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector(".material-icons", text: "remove_circle_outline")
    end
  end

  def assert_no_subject(subject_name)
    expect(page).to have_no_selector("li", text: subject_name)
  end

  def assert_subject_with_semester_selector(subject_name)
    expect(page).to have_text subject_name
    within_subject_row(subject_name) do
      expect(page).to have_selector(".material-icons", text: "add_circle_outline")
      expect(page).to have_selector("select", text: 'Sem. 1')
    end
  end

  def assert_subject_selector_contains(subject_name_with_code)
    find('.choices').click
    within('.choices__list--dropdown') do
      expect(page).to have_text(subject_name_with_code)
    end
    find('.choices').click
  end

  def assert_subject_not_in_selector(subject_name_with_code)
    find('.choices').click
    within('.choices__list--dropdown') do
      expect(page).to have_no_text(subject_name_with_code)
    end
    find('.choices').click
  end

  def within_not_planned_approved_subjects(&block)
    card = find(".bg-white", text: "Materias aprobadas sin semestre asignado")
    card.click if card_collapsed?(card)

    within(card, &block)
  end

  def within_semester_section(semester, &block)
    within(:xpath, "//h3[contains(text(), '#{semester}')]/../..", &block)
  end

  def within_add_subject_section(&block)
    within(:xpath, ".//form[.//select[@name='subject_plan[subject_id]']]", &block)
  end

  def select_from_choices(option_text)
    find('.choices').click
    find('.choices__input').fill_in(with: option_text)
    find('.choices__item--choice', text: option_text).click
  end

  private

  def within_subject_row(subject_name, &block)
    within("form", text: subject_name, &block)
  end

  def card_collapsed?(card) = card.has_selector?(".material-icons", text: "chevron_right")

  def assert_banner_present(message)
    within('[data-controller="banner"]') do
      expect(page).to have_text(message)
    end
  end

  def assert_banner_dismissed
    expect(page).not_to have_css('[data-controller="banner"]')
  end
end
