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

    def self.scrape
      Capybara.configure do |config|
        config.default_driver = ENV["HEADLESS"] == "false" ? :selenium_chrome : :selenium_chrome_headless
        config.run_server = false
        config.save_path = "tmp/capybara"
        config.threadsafe = true
      end

      degrees = YAML.load_file(Rails.root.join("db/data/degrees.yml"))
      degrees.each do |career|
        new(career).scrape if career["enabled"]
      end
    end

    attr_reader :career

    def initialize(career)
      @career = career
    end

    def scrape
      Rails.logger.info "Scraping career: #{career["name"]}"
      groups = {}
      subjects = {}

      go_to_groups_and_subjects_page
      process_groups_and_subjects(groups, subjects)

      go_to_prerequisites_page
      prerequisites = process_prerequisites(subjects)

      prerequisites.each do |prerequisite_tree|
        add_missing_exams_and_subjects(prerequisite_tree, subjects)
      end

      scraped_prerequisites =
        prerequisites.sort_by { |e| [e[:subject_code], e[:is_exam] ? 1 : 0] }.map(&:deep_stringify_keys)
      optional_inco_subjects = load_this_semester_inco_subjects

      write_yml("scraped_subject_groups", groups.deep_stringify_keys.sort.to_h)
      write_yml("scraped_subjects", subjects.deep_stringify_keys.sort.to_h)
      write_yml("scraped_prerequisites", scraped_prerequisites)
      if career["name"] == "INGENIERIA EN COMPUTACION"
        write_yml("scraped_optional_subjects", optional_inco_subjects.sort)
      end
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    private

    def write_yml(name, data)
      career_dir = career["name"].underscore.tr(" ", "_")
      dir_path = Rails.root.join("db/data/#{career_dir}")

      Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

      File.write(dir_path.join("#{name}.yml"), data.to_yaml)
    end

    def go_to_groups_and_subjects_page
      visit "https://bedelias.udelar.edu.uy"
      click_on "PLANES DE ESTUDIO"
      click_on "Planes de estudio / Previas"

      execute_script("$.fx.off = true;") # Disable jQuery effects

      find('.ui-accordion-header', text: 'TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA').click
      find('td', text: 'FING - FACULTAD DE INGENIERÍA', visible: false).click

      find('span', text: 'Planes de estudio - FING')

      wait_for_loading_widget_to_disappear

      find('.ui-column-filter').set('INGENIERIA EN COMPUTACION')

      all('tr', text: career["name"], match: :prefer_exact).each do |row|
        if row.has_selector?('td', text: 'Grado', match: :prefer_exact)
          row.find('.ui-row-toggler').click
          break
        end
      end

      within('.ui-expanded-row-content', text: 'Planes') do
        find('tr', text: career["current_plan"]).click_on "Ver más datos"
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
            subjects[code] = { code:, name:, credits: credits.to_i, has_exam: false, subject_group: group_code }
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
          Rails.logger.info "#{name.text} (#{type.text})"

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
    end

    def go_to_page(page)
      # Requested page is not visible in the pages list
      if page > all('.ui-paginator-page').last.text.to_i
        # Navigate to last page because as of 3/3/2023 there are only 16 pages,
        # so all pages are visible from either the first or last page.
        # Would be more correct to navigate to the last visible page and repeat
        # until we see the requested page, but that would require extra navigations
        # after processing each approvable, making it slower.
        # If the number of pages increases in the future, this approach will raise
        # an error if it can't find the requested page. We can implement a better
        # (and maybe slower) approach when/if this happens
        find('.ui-paginator-last').click
        has_selector?(".ui-paginator-last.ui-state-disabled")
      end

      find('.ui-paginator-page', text: page, match: :prefer_exact).click
      has_selector?(".ui-paginator-page.ui-state-active", text: "#{page}")
    end

    def add_missing_exams_and_subjects(prerequisite_tree, subjects)
      if prerequisite_tree[:type] == 'subject'
        if subjects[prerequisite_tree[:subject_needed_code]]
          subjects[prerequisite_tree[:subject_needed_code]][:has_exam] = true if prerequisite_tree[:needs] == 'exam'
        else
          subjects[prerequisite_tree[:subject_needed_code]] = {
            code: prerequisite_tree[:subject_needed_code],
            name: prerequisite_tree[:subject_needed_name],
            credits: 0,
            has_exam: prerequisite_tree[:needs] == 'exam',
            subject_group: nil,
          }
        end
      elsif prerequisite_tree[:type] == 'logical'
        prerequisite_tree[:operands].each do |operand|
          add_missing_exams_and_subjects(operand, subjects)
        end
      end
    end

    def load_this_semester_inco_subjects
      visit "https://www.fing.edu.uy/es/node/43774"

      find('table').all('tr').each_with_object([]) do |row, subjects|
        cells = row.all('td')
        next unless cells&.size == 6

        name = cells[0]&.text&.strip
        codigo = cells[1]&.text&.strip

        next unless name && codigo
        next if name == "Curso" # the first row is the header
        next if codigo == "nueva" # there's one row with "nueva" as the code

        subjects << codigo
      end
    end

    def wait_for_loading_widget_to_disappear
      if has_css?('.ui-widget-overlay')
        assert_no_selector('.ui-widget-overlay')
      end
    end
  end
end
