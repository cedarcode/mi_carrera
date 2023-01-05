class PrerequisitesPage < BedeliasPage
  def reached_last_page?
    find(:css, 'span.ui-paginator-next')[:class].include?('disabled')
  end

  def move_to_next_page
    find(:css, 'span.ui-icon-seek-next').click
  end

  def current_page_number
    find(:css, 'span.ui-paginator-page.ui-state-active').text.to_i
  end

  def approvables_count_in_page
    all("//tr[@data-ri]").count
  end

  def approvable_node(approvable_index)
    find("//tr[@data-ri=#{approvable_index}]")
  end

  def approvables_in_current_page
    all("//tr[@data-ri]")
  end

  def click_on_see_more(approvable_node)
    approvable_node.find("td[3]/a").click
  end

  def advance_to_page(page)
    return if current_page_number == page

    find("//span[contains(@class, 'ui-paginator-page') and text()='#{page}' ]")&.click
  rescue Capybara::ElementNotFound
    advance_to_page(last_visible_page_number)
    advance_to_page(page)
  end

  def last_visible_page_number
    find(:css, 'span.ui-paginator-pages span:last-child').text.to_i
  end

  def for_each_page
    loop do
      yield(current_page_number)

      break if reached_last_page?

      move_to_next_page
      sleep 0.5
    end
  end

  def approvable_details(approvable_node)
    column = approvable_node.first("td")
    code = column.text.split(' - ')[0]
    name = column.text.split(' - ')[1]
    type = column.first("following-sibling::td").text
    is_exam = approvable_node.first("td[2]").text == "Examen" # from column 'Tipo'

    {
      code: code,
      type: type,
      name: name,
      is_exam: is_exam
    }
  end

  def for_each_approvable
    approvable_index = 0
    for_each_page do |current_page_number|
      approvables_count_in_page.times do
        yield(approvable_node(approvable_index), current_page_number)
        # if the page was reloaded, go back to the current page
        advance_to_page(current_page_number)
        approvable_index += 1
      end
    end
  end
end
