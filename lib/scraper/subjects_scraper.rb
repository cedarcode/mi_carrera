require 'scraper/base'
require 'scraper/prerequisites_tree_page'

module Scraper
  class SubjectsScraper < Base
    # 5265 - CIENCIAS HUMANAS Y SOCIALES - min: 10 créditos
    GROUP_CODE_NAME_CREDITS_REGEX = /\A(\w+) - (.+) - (?:min): (\d+)(?: créditos)\z/
    # SRN14 - MATEMÁTICA DISCRETA I - créditos: 10
    # FF1-7 - CREDITOS ASIGNADOS POR REVALIDA - créditos: 7
    # FL2.6 - CREDITOS ASIGANDOS POR REVALIDA - créditos: 6
    SUBJECT_CODE_NAME_CREDITS_REGEX = /\A((?:\w|\.|\-)+) - (.+) - (?:créditos): (\d+)(?: programa)?\z/

    def scrape
      logger.info "Starting to scrape subjects"
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

      write_yml("scraped_subject_groups", groups.deep_stringify_keys.sort.to_h)
      write_yml("scraped_subjects", subjects.deep_stringify_keys.sort.to_h)
      write_yml("scraped_prerequisites", scraped_prerequisites)
    rescue
      Rails.logger.info save_screenshot
      raise
    end

    private

    def go_to_groups_and_subjects_page
      visit "https://bedelias.udelar.edu.uy"
      click_on "PLANES DE ESTUDIO"
      click_on "Planes de estudio / Previas"

      select_degree_in_accordion

      within('.ui-expanded-row-content', text: 'Planes') do
        find('tr', text: plan).click_on "Ver más datos"
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
      max_pages = MAX_PAGES || total_pages

      threaded_scrape(max_pages) do |slice|
        process_prerequisites_slice(subjects, slice)
      end
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
  end
end
