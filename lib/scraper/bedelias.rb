require 'capybara'
require 'capybara/dsl'
require 'scraper/prerequisites_tree_page'

module Scraper
  class Bedelias
    include Capybara::DSL

    # 5265 - CIENCIAS HUMANAS Y SOCIALES - min: 10 créditos
    GROUP_CODE_NAME_CREDITS_REGEX = /\A(\w+) - (.+) - (?:min): (\d+)(?: créditos)\z/
    # SRN14 - MATEMÁTICA DISCRETA I - créditos: 10
    # FF1-7 - CREDITOS ASIGNADOS POR REVALIDA - créditos: 7
    # FL2.6 - CREDITOS ASIGANDOS POR REVALIDA - créditos: 6
    SUBJECT_CODE_NAME_CREDITS_REGEX = /\A((?:\w|\.|\-)+) - (.+) - (?:créditos): (\d+)(?: programa)?\z/
    MAX_PAGES = ENV["MAX_PAGES"]&.to_i
    THREADS = (ENV['THREADS'] || 6).to_f
    INVALID_PERIOD = 'Instancias de dictado con período finalizado'
    VALID_PERIOD = 'Instancias de dictado con período habilitado'

    def self.scrape
      Capybara.configure do |config|
        config.default_driver = ENV["HEADLESS"] == "false" ? :selenium_chrome : :selenium_chrome_headless
        config.run_server = false
        config.save_path = "tmp/capybara"
        config.threadsafe = true
      end

      degrees = Rails.configuration.degrees
      degrees.each do |degree|
        new(degree).scrape
      end
    end

    def initialize(degree)
      @degree = degree
      @logger = Rails.logger.tagged("Scraper - #{degree[:bedelias_name]}")
    end

    def scrape
      logger.info "Starting to scrape degree"
      groups = {}
      subjects = {}
      current_semester_subjects = []

      go_to_groups_and_subjects_page
      process_groups_and_subjects(groups, subjects)

      go_to_prerequisites_page
      prerequisites = process_prerequisites(subjects)

      prerequisites.each do |prerequisite_tree|
        add_missing_exams_and_subjects(prerequisite_tree, subjects)
      end

      scraped_prerequisites =
        prerequisites.sort_by { |e| [e[:subject_code], e[:is_exam] ? 1 : 0] }.map(&:deep_stringify_keys)

      current_semester_subjects += load_current_semester_subjects(VALID_PERIOD)
      current_semester_subjects += load_current_semester_subjects(INVALID_PERIOD)
      write_yml("scraped_current_semester_subjects", current_semester_subjects.sort)

      write_yml("scraped_subject_groups", groups.deep_stringify_keys.sort.to_h)
      write_yml("scraped_subjects", subjects.deep_stringify_keys.sort.to_h)
      write_yml("scraped_prerequisites", scraped_prerequisites)
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    private

    attr_reader :degree, :logger

    def write_yml(name, data)
      dir_path = Rails.root.join("db/data/#{degree[:id]}")

      Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

      File.write(dir_path.join("#{name}.yml"), data.to_yaml)
    end

    def go_to_groups_and_subjects_page
      visit "https://bedelias.udelar.edu.uy"
      click_on "PLANES DE ESTUDIO"
      click_on "Planes de estudio / Previas"

      select_degree_in_accordion

      within('.ui-expanded-row-content', text: 'Planes') do
        find('tr', text: degree[:current_plan]).click_on "Ver más datos"
      end
    end

    def select_degree_in_accordion
      execute_script("$.fx.off = true;") # Disable jQuery effects

      find('.ui-accordion-header', text: 'TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA').click
      find('td', text: 'FING - FACULTAD DE INGENIERÍA', visible: false).click

      find('span', text: ' - FING')

      wait_for_loading_widget_to_disappear

      find('.ui-column-filter').set(degree[:bedelias_name])

      all('tr', text: degree[:bedelias_name], match: :prefer_exact).each do |row|
        if row.has_selector?('td', text: 'Grado', match: :prefer_exact)
          row.find('.ui-row-toggler').click
          break
        end
      end
    end

    def process_groups_and_subjects(groups, subjects)
      node_type = "[data-nodetype='Grupo']"
      selector = ".arbolComposicion #{node_type}:not(:has(#{node_type})) > .ui-treenode-content > .ui-treenode-label"
      group_nodes = all(selector, visible: false)

      group_nodes.each do |group_node|
        group_code, name, credits = GROUP_CODE_NAME_CREDITS_REGEX.match(group_node.text(:all)).captures
        groups[group_code] = { code: group_code, name:, min_credits: credits.to_i }
        subject_nodes_in_group = group_node.all(:xpath, '..//..//li[@data-nodetype="Materia"]', visible: false)

        subject_nodes_in_group.each do |subject_node|
          match = SUBJECT_CODE_NAME_CREDITS_REGEX.match(subject_node.text(:all))
          if match
            code, name, credits = match.captures
            subjects[code] ||= { code:, name:, subject_groups: [], has_exam: false }
            subjects[code][:subject_groups] << { group: group_code, credits: credits.to_i }
          else
            raise "Regex didn't match for subject: #{subject_node.text(:all)}"
          end
        end
      end
    end

    def go_to_prerequisites_page
      click_on 'Sistema de previaturas'
    end

    def process_prerequisites(subjects)
      Thread.abort_on_exception = true

      find('.ui-paginator-last').click
      has_selector?(".ui-paginator-last.ui-state-disabled")

      total_pages = find(".ui-paginator-page.ui-state-active").text.to_i

      max_pages = MAX_PAGES || total_pages

      1.upto(max_pages).each_slice((max_pages / THREADS).ceil).map do |slice|
        Thread.new do
          using_session(Capybara::Session.new(page.mode)) do
            process_prerequisites_slice(subjects, slice)
          end
        end
      end.flat_map(&:value)
    end

    def process_prerequisites_slice(subjects, slice)
      go_to_groups_and_subjects_page
      go_to_prerequisites_page

      slice.flat_map do |page|
        go_to_page(page)

        # Need to iterate over row ids (data-ri) rather than the row nodes
        # because each time we navigate to the details page for an approvable and
        # navigate back to this index page, the nodes are different
        all('[data-ri]').map { |node| node['data-ri'] }.map do |row_id|
          approvable_row = find("[data-ri='#{row_id}']")
          name, type = approvable_row.all('td')[0..1]
          logger.info "#{name.text} (#{type.text})"

          subject_code = /\A(\w+) - .*\z/.match(name.text).captures[0]
          is_exam = type.text == "Examen"

          subjects[subject_code][:has_exam] ||= is_exam if subjects[subject_code]

          approvable_row.click_on "Ver más"

          wait_for_loading_widget_to_disappear

          prereq = Scraper::PrerequisitesTreePage.prerequisite_tree(find("[data-rowkey='root']"))

          click_on 'Volver'
          # Clicking on 'Volver' takes us to the first page so we have
          # to navigate to the page that we previously were.
          go_to_page(page)

          prereq.merge(subject_code:, is_exam:)
        end
      end
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    def go_to_page(page)
      # Loop until the desired page is visible in the paginator
      until page_visible?(page)
        last_visible_page = all('.ui-paginator-page').last

        last_visible_page.click
        has_selector?('.ui-paginator-page.ui-state-active', text: last_visible_page.text)
      end

      find('.ui-paginator-page', text: page, match: :prefer_exact).click
      has_selector?('.ui-paginator-page.ui-state-active', text: page.to_s)
    end

    def page_visible?(page)
      has_selector?('.ui-paginator-page', text: page, match: :prefer_exact)
    end

    def add_missing_exams_and_subjects(prerequisite_tree, subjects)
      if prerequisite_tree[:type] == 'subject'
        if subjects[prerequisite_tree[:subject_needed_code]]
          subjects[prerequisite_tree[:subject_needed_code]][:has_exam] = true if prerequisite_tree[:needs] == 'exam'
        else
          subjects[prerequisite_tree[:subject_needed_code]] = {
            code: prerequisite_tree[:subject_needed_code],
            name: prerequisite_tree[:subject_needed_name],
            has_exam: prerequisite_tree[:needs] == 'exam',
            subject_groups: [],
          }
        end
      elsif prerequisite_tree[:type] == 'logical'
        prerequisite_tree[:operands].each do |operand|
          add_missing_exams_and_subjects(operand, subjects)
        end
      end
    end

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
      Thread.abort_on_exception = true

      go_to_current_semester_subjects_page
      ensure_accordion_open(inscription_period)
      find('.ui-paginator-last').click
      has_selector?(".ui-paginator-last.ui-state-disabled")
      total_pages = find(".ui-paginator-page.ui-state-active").text.to_i
      find(".ui-paginator-first").click

      max_pages = MAX_PAGES || total_pages

      1.upto(max_pages).each_slice((max_pages / THREADS).ceil).map do |slice|
        Thread.new do
          using_session(Capybara::Session.new(page.mode)) do
            load_current_semester_subjects_slice(inscription_period, slice)
          end
        end
      end.flat_map(&:value).uniq
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

    def wait_for_loading_widget_to_disappear
      if has_css?('.ui-widget-overlay')
        assert_no_selector('.ui-widget-overlay')
      end
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
