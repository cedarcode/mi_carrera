require 'capybara'
require 'capybara/dsl'
require 'scraper/prerequisites_tree_page'

module Scraper
  module Bedelias
    extend self

    include Capybara::DSL

    # 5265 - CIENCIAS HUMANAS Y SOCIALES - min: 10 créditos
    # SRN14 - MATEMÁTICA DISCRETA I - créditos: 10
    CODE_NAME_CREDITS_REGEX = /\A(\w+) - (.+) - (?:min|créditos): (\d+)( créditos)?\z/
    MAX_PAGES = ENV["MAX_PAGES"]&.to_i
    THREADS = (ENV['THREADS'] || 6).to_f

    def scrape
      Capybara.configure do |config|
        config.default_driver = ENV["HEADLESS"] == "false" ? :selenium_chrome : :selenium_chrome_headless
        config.run_server = false
        config.save_path = "tmp"
        config.threadsafe = true
      end

      groups = {}
      subjects = {}

      go_to_groups_and_subjects_page
      process_groups_and_subjects(groups, subjects)

      go_to_prerequisites_page
      prerequisites = process_prerequisites(subjects)

      prerequisites.each do |prerequisite_tree|
        add_missing_exams_and_subjects(prerequisite_tree, subjects)
      end

      File.write(Rails.root.join("db/data/scraped_subject_groups.yml"), groups.deep_stringify_keys.to_yaml)
      File.write(Rails.root.join("db/data/scraped_subjects.yml"), subjects.deep_stringify_keys.to_yaml)
      File.write(Rails.root.join("db/data/scraped_prerequisites.yml"), prerequisites.map(&:deep_stringify_keys).to_yaml)
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    private

    def go_to_groups_and_subjects_page
      visit "https://bedelias.udelar.edu.uy"
      click_on "PLANES DE ESTUDIO"
      click_on "Planes de estudio / Previas"

      execute_script("$.fx.off = true;") # Disable jQuery effects

      find('h3', text: 'TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA').click
      find('span', text: 'FING - FACULTAD DE INGENIERÍA', visible: false).click

      within('tr', text: 'INGENIERIA EN COMPUTACION', match: :prefer_exact) do
        find('.ui-row-toggler').click
      end
      within('.ui-expanded-row-content', text: 'Planes') do
        find('tr', text: '1997').click_on "Ver más datos"
      end
    end

    def process_groups_and_subjects(groups, subjects)
      node_type = "[data-nodetype='Grupo']"
      selector = ".arbolComposicion #{node_type}:not(:has(#{node_type})) > .ui-treenode-content > .ui-treenode-label"
      group_nodes = all(selector, visible: false)

      group_nodes.each do |group_node|
        group_code, name, credits = CODE_NAME_CREDITS_REGEX.match(group_node.text(:all)).captures
        groups[group_code] = { code: group_code, name:, min_credits: credits.to_i }
        subject_nodes_in_group = group_node.all(:xpath, '..//..//li[@data-nodetype="Materia"]/span', visible: false)

        subject_nodes_in_group.each do |subject_node|
          code, name, credits = CODE_NAME_CREDITS_REGEX.match(subject_node.text(:all)).captures
          subjects[code] = { code:, name:, credits: credits.to_i, has_exam: false, subject_group: group_code }
        end
      end
    end

    def go_to_prerequisites_page
      click_on 'Sistema de previaturas'
    end

    def process_prerequisites(subjects)
      Thread.abort_on_exception = true

      total_pages = /\(\d+ de (\d+)\)/.match(find(".ui-paginator-current").text).captures[0]
      max_pages = MAX_PAGES || total_pages.to_i

      1.upto(max_pages).each_slice((max_pages / THREADS).ceil).map do |slice|
        Thread.new do
          using_session(Capybara::Session.new(page.mode)) do
            process_prerequisites_slice(subjects, slice, total_pages)
          end
        end
      end.flat_map(&:value)
    end

    def process_prerequisites_slice(subjects, slice, total_pages)
      go_to_groups_and_subjects_page
      go_to_prerequisites_page

      slice.flat_map do |page|
        go_to_page(page, total_pages)

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

          prereq = Scraper::PrerequisitesTreePage.prerequisite_tree(find("[data-rowkey='root']"))

          click_on 'Volver'
          # Clicking on 'Volver' takes us to the first page so we have
          # to navigate to the page that we previously were.
          go_to_page(page, total_pages)

          prereq.merge(subject_code:, is_exam:)
        end
      end
    end

    def go_to_page(page, total_pages)
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
        has_selector?(".ui-paginator-current", text: "(#{total_pages} de #{total_pages})")
      end

      find('.ui-paginator-page', text: page, match: :prefer_exact).click
      has_selector?(".ui-paginator-current", text: "(#{page} de #{total_pages})")
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
  end
end
