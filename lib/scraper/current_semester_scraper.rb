require 'scraper/base'

module Scraper
  class CurrentSemesterScraper < Base
    INVALID_PERIOD = 'Instancias de dictado con período finalizado'
    VALID_PERIOD = 'Instancias de dictado con período habilitado'

    def scrape
      logger.info "Starting to scrape current semester subjects"
      current_semester_subjects = []

      current_semester_subjects += load_current_semester_subjects(VALID_PERIOD)
      current_semester_subjects += load_current_semester_subjects(INVALID_PERIOD)
      write_yml("scraped_current_semester_subjects", current_semester_subjects.sort)
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    private

    def go_to_current_semester_subjects_page
      visit "https://bedelias.udelar.edu.uy"
      click_on "PLANES DE ESTUDIO"
      click_on "Calendarios"

      select_degree_in_accordion

      within('.ui-expanded-row-content', text: 'Planes') do
        within('tr', text: degree[:current_plan]) do
          first('a').click
        end
      end
    end

    def load_current_semester_subjects(inscription_period)
      go_to_current_semester_subjects_page
      ensure_accordion_open(inscription_period)

      max_pages = MAX_PAGES || total_pages

      find(".ui-paginator-first").click

      threaded_scrape(max_pages) do |slice|
        load_current_semester_subjects_slice(inscription_period, slice)
      end.uniq
    end

    def load_current_semester_subjects_slice(inscription_period, slice)
      go_to_current_semester_subjects_page

      subjects = []

      slice.flat_map do |page|
        ensure_accordion_open(inscription_period)
        go_to_page(page)

        all('[data-ri]').map { |node| node['data-ri'] }.map do |row_id|
          ensure_accordion_open(inscription_period)
          go_to_page(page)

          subject_row = find("[data-ri='#{row_id}']")
          subject_code = subject_row.all('td')[0].text.split(' ').last

          subjects << subject_code if matches_current_period?(subject_row)
        end
      end

      subjects
    end

    def matches_current_period?(subject_row)
      subject_row.click_on 'Ver más datos'

      periods = all(:xpath, "//td[normalize-space(text())='Período:']/following-sibling::td/span").map(&:text)

      click_on 'Volver'

      periods.any? do |period|
        period_code = period[/\A\d{6}/]
        period_code == current_period
      end
    end

    # Bedelias represents academic periods using a YYYY-{01||02} format.
    # For example, "2026-01" corresponds to the first semester of 2026,
    # and "2026-02" corresponds to the second semester of the same year.
    def current_period
      date  = Time.current
      year  = date.year
      half  = date.month < 8 ? "01" : "02"

      "#{year}#{half}"
    end

    def ensure_accordion_open(text)
      header = find("div.ui-accordion-header", text: text, match: :prefer_exact)

      unless header[:class].include?("ui-state-active")
        header.click
        wait_for_loading_widget_to_disappear
        has_selector?("div.ui-accordion-header.ui-state-active", text: text, match: :prefer_exact)
        has_css?('#accordDict\\tabDictF', visible: text == INVALID_PERIOD)
        has_css?('#accordDict\\tabDictH', visible: text == VALID_PERIOD)
      end
    end
  end
end
