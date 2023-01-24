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

  def approvables_index_in_current_page
    all("//tr[@data-ri]").each_with_object([]) do |approvable_node, array|
      array << approvable_node['data-ri'].to_i
    end
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

    if last_visible_page_number >= page
      find(:css, 'span.ui-paginator-page', text: page).click
    else
      advance_to_page(last_visible_page_number)
      advance_to_page(page)
    end
  end

  def last_visible_page_number
    find(:css, 'span.ui-paginator-pages span:last-child').text.to_i
  end

  def for_each_page
    loop do
      yield(current_page_number)

      sleep 0.5
      break if reached_last_page?

      move_to_next_page
      sleep 0.5
    end
  end

  def approvable_details(approvable_node)
    column = approvable_node.first("td")
    code, name = column.text.split(' - ')
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
    for_each_page do |current_page_number|
      approvables_index_in_current_page.each do |approvable_index|
        yield(approvable_node(approvable_index), current_page_number)
        # if the page was reloaded, go back to the current page
        advance_to_page(current_page_number)
      end
    end
  end
end
