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
end
