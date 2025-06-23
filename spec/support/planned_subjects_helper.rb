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

  def within_each_semester_section(&block)
    %w[Primer Segundo Tercer Cuarto Quinto Sexto Séptimo Octavo Noveno Décimo].each do |ordinal_number|
      within_semester_section("#{ordinal_number} semestre", &block)
    end
  end

  def within_add_subject_section(&block)
    within(:xpath, ".//form[.//select[@name='subject_plan[subject_id]']]", &block)
  end

  def select_from_choices(option_text)
    find('.choices').click
    find('.choices__input').fill_in(with: option_text)
    find('.choices__item--choice', text: option_text).click
  end

  def move_subject_to_semester(subject_name, semester)
    subject_element_drag_handle = within_subject_row(subject_name) { find("span", text: 'drag_handle') }
    semester_subjects_list = page.find(:xpath, "//ul[../div[h3[contains(text(), '#{semester}')]]]")
    subject_element_drag_handle.drag_to(semester_subjects_list)
  end

  private

  def within_subject_row(subject_name, &block)
    within("li", text: subject_name, &block)
  end

  def card_collapsed?(card) = card.has_selector?(".material-icons", text: "chevron_right")
end
