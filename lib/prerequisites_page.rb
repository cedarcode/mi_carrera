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

  def see_more(row)
    row.find("td[3]/a").click
  end

  def advance_to_page(page)
    found = false
    while !found
      begin
        # click the paginator-page with the number page
        find("//span[ contains(@class, 'ui-paginator-page') and text()='#{page}' ]")&.click
        found = true
      rescue Capybara::ElementNotFound
        # find last span inside span with class ui-paginator-pages and click
        find("//span[contains(@class, 'ui-paginator-pages')]/span[last()]").click
      end
    end
  end
end
