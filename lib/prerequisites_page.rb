class PrerequisitesPage < BedeliasPage
  def reached_last_page?
    find("//span[contains(@class, 'ui-paginator-next')]")[:class].include?('disabled')
  end

  def move_to_next_page
    find("//span[contains(@class, 'ui-icon-seek-next')]").click
  end

  def current_page_number
    find("//span[ contains(@class, 'ui-paginator-page') and contains(@class, 'ui-state-active') ]").text.to_i
  end

  def row_count_in_page
    all("//tr[@data-ri]").count
  end

  def row_with_index(index)
    find("//tr[@data-ri=#{index}]")
  end

  def rows_in_current_page
    all("//tr[@data-ri]")
  end

  def click_on_see_more(row)
    row.find("td[3]/a").click
  end

  def advance_to_page(page)
    find("//span[contains(@class, 'ui-paginator-page') and text()='#{page}' ]")&.click
  rescue Capybara::ElementNotFound
    advance_to_page(last_visible_page_number)
    advance_to_page(page)
  end

  def last_visible_page_number
    find("//span[contains(@class, 'ui-paginator-pages')]/span[last()]").text.to_i
  end

  def for_each_page
    loop do
      yield(current_page_number)

      move_to_next_page
      sleep 0.5

      break if reached_last_page?
    end
  end
end
