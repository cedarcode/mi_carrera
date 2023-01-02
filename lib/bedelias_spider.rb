require 'kimurai'
require 'pp'
require 'bedelias_page'
require 'curriculum_page'
require 'prerequisites_page'
require 'prerequisites_tree_page'

class BedeliasSpider < Kimurai::Base
  @name = "bedelias_spider"
  @engine = :selenium_chrome

  ROWS_PER_PAGE = 20

  def bedelias_page
    @bedelias_page ||= BedeliasPage.new(browser)
  end

  def curriculum_page
    @curriculum_page ||= CurriculumPage.new(browser)
  end

  def prerequisites_page
    @prerequisites_page ||= PrerequisitesPage.new(browser)
  end

  def prerequisites_tree_page
    @prerequisites_tree_page ||= PrerequisitesTreePage.new(browser)
  end

  def parse_subjects(*_args)
    bedelias_page.visit_curriculum

    subjects = {}

    # get all groups
    curriculum_page.groups.each do |group_node|
      # for each group, get code name min_credits and save it to a json file
      group_details = curriculum_page.group_details(group_node)

      puts "Generating subject group #{group_details[:code]} - #{group_details[:name]}"

      path = File.join(Rails.root, "db", "seeds", "scraped_subject_groups.json")
      save_to path, group_details, format: :pretty_json, position: false

      # for each group, get all subjects
      curriculum_page.subjects_in_group(group_node).each do |subject|
        # for each subject, get code, name, credits add the group code
        subject_details = curriculum_page.subject_details(subject)
        subject_details[:subject_group] = group_details[:code]
        # add the subject to the hash, with code as key
        subjects[subject_details[:code]] = subject_details
      end
    end

    # got to the prerequisites page
    bedelias_page.visit_prerequisites

    prerequisites_page.for_each_page do |current_page_number|
      # for each page, get all rows
      prerequisites_page.rows_in_current_page.each do |subject_row|
        subject_row_details = curriculum_page.subject_row_details(subject_row)

        if subjects[subject_row_details[:subject_code]].nil?
          puts "Warning: skipping #{subject_row_details[:subject_name]}"
          next
        end

        puts "#{current_page_number}/#{subject_row_details[:index]} Generating
              #{subject_row_details[:subject_name]}, #{subject_row_details[:type]}"

        # save the subject and whether it has an exam
        if subject_row_details[:type] == "Curso"
          subjects[subject_row_details[:subject_code]][:has_exam] = false
        elsif subject_row_details[:type] == "Examen"
          subjects[subject_row_details[:subject_code]][:has_exam] = true
        end
      end
    end

    # save to a file
    path = File.join(Rails.root, "db", "seeds", "scraped_subjects.json")
    subjects.values.each do |subject|
      save_to path, subject, format: :pretty_json, position: false
    end
  end

  def parse_prerequisites(*_args)
    bedelias_page.visit_prerequisites
    row_index = 0
    prerequisites_page.for_each_page do |current_page_number|
      prerequisites_page.row_count_in_page.times do
        subject_row = prerequisites_page.row_with_index(row_index)
        subject_row_details = curriculum_page.subject_row_details(subject_row)

        puts(
          "#{current_page_number}/#{row_index} - Generating prerequisite for
          #{subject_row_details[:subject_code]}, #{subject_row_details[:is_exam] ? "exam" : "course"}"
        )

        prerequisites_page.click_on_see_more(subject_row) # 'Ver más'

        tree = prerequisites_tree_page.root
        prerequisite = create_prerequisite_tree(tree, subject_row_details[:subject_code], subject_row_details[:is_exam])
        path = File.join(Rails.root, "db", "seeds", "scraped_prerequisites.json")
        save_to path, prerequisite, format: :pretty_json, position: false

        prerequisites_tree_page.back

        prerequisites_page.advance_to_page(current_page_number)
        row_index += 1
      end
    end
  end

  private

  def create_prerequisite_tree(original_prerequisite, subject = nil, exam = false)
    prerequisite = {}
    if subject
      prerequisite[:subject] = subject
      prerequisite[:exam] = exam
    end
    node_type = original_prerequisite['data-nodetype']
    node_content = prerequisites_tree_page.node_content_from_node(original_prerequisite)

    if node_type == 'default'
      if node_content.include?('créditos en el Plan:')
        prerequisite[:type] = 'credits'
        prerequisite[:credits] = prerequisites_tree_page.credits_from_node(original_prerequisite)
      elsif node_content.include?('aprobación') || node_content.include?('actividad')
        prerequisite[:type] = 'logical'
        if prerequisites_tree_page.only_one_approval_needed?(original_prerequisite)
          prerequisite[:logical_operator] = "or"
        else # change: 'n' approvals needed out of a list of 'm' subjects when 'n'<'m' is not considered
          prerequisite[:logical_operator] = "and"
        end
        prerequisite[:operands] = []
        subjects = prerequisites_tree_page.extract_subjects_from(node_content)

        subjects.each do |s|
          prerequisite[:operands] += [
            { type: 'subject', subject_needed: s[:subject_needed], needs: s[:needs] }
          ]
        end
      elsif node_content.include?('Curso aprobado')
        prerequisite[:type] = 'subject'
        prerequisite[:needs] = 'course'
        prerequisite[:subject_needed] = prerequisites_tree_page.subject_code(node_content)
      elsif node_content.include?('Examen aprobado')
        prerequisite[:type] = 'subject'
        prerequisite[:needs] = 'exam'
        prerequisite[:subject_needed] = prerequisites_tree_page.subject_code(node_content)
      elsif node_content.include?('Aprobada')
        prerequisite[:type] = 'subject'
        prerequisite[:subject_needed] = prerequisites_tree_page.subject_code(node_content)
        prerequisite[:needs] = 'all'
      elsif node_content.include?('Inscripción a Curso')
        prerequisite[:type] = 'subject'
        prerequisite[:subjedt_needed] = prerequisites_tree_page.subject_code(node_content)
        prerequisite[:needs] = 'enrollment'
      end
    elsif node_type == 'cag' # 'créditos en el Grupo:'
      prerequisite[:type] = 'credits'
      prerequisite[:credits] = prerequisites_tree_page.credits_from_node(original_prerequisite)
      prerequisite[:group] = prerequisites_tree_page.group_from_node(original_prerequisite)
    elsif node_type == 'y'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'and'
      prerequisites_tree_page.expand_prerequisites_tree(original_prerequisite)
      prerequisite[:operands] = []
      subtree_roots = prerequisites_tree_page.subtrees_roots(original_prerequisite)
      subtree_roots.each do |subtree_root|
        prerequisite[:operands] += [create_prerequisite_tree(subtree_root)]
      end
    elsif node_type == 'no'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'not'
      prerequisites_tree_page.expand_prerequisites_tree(original_prerequisite)
      prerequisite[:operands] = []
      subtree_roots = prerequisites_tree_page.subtrees_roots(original_prerequisite)
      subtree_roots.each do |subtree_root|
        prerequisite[:operands] += [create_prerequisite_tree(subtree_root)]
      end
    elsif node_type == 'o'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'or'
      prerequisites_tree_page.expand_prerequisites_tree(original_prerequisite)
      prerequisite[:operands] = []
      subtree_roots = prerequisites_tree_page.subtrees_roots(original_prerequisite)
      subtree_roots.each do |subtree_root|
        prerequisite[:operands] += [create_prerequisite_tree(subtree_root)]
      end
    end
    prerequisite
  end

  def click(xpath_selector, scope = browser)
    find(xpath_selector, scope).click
  end

  def find(xpath_selector, scope = browser)
    scope.find(:xpath, xpath_selector)
  end
end
