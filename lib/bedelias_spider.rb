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

    prerequisites_page.for_each_approvable do |approvable_node, current_page_number|
      approvable_details = prerequisites_page.approvable_details(approvable_node)

      if subjects[approvable_details[:code]].nil?
        puts "Warning: skipping #{approvable_details[:code]} - #{approvable_details[:name]}"
        next
      end

      puts(
        "Page #{current_page_number} Generating " +
        "#{approvable_details[:code]} - #{approvable_details[:name]}, #{approvable_details[:type]}"
      )

      # save the subject and whether it has an exam
      if approvable_details[:type] == "Curso"
        subjects[approvable_details[:code]][:has_exam] = false
      elsif approvable_details[:type] == "Examen"
        subjects[approvable_details[:code]][:has_exam] = true
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

    prerequisites_page.for_each_approvable do |approvable_node, current_page_number|
      approvable_details = prerequisites_page.approvable_details(approvable_node)

      puts(
        "Page #{current_page_number} - Generating prerequisite for " +
        "#{approvable_details[:code]}, #{approvable_details[:is_exam] ? "exam" : "course"}"
      )

      prerequisites_page.click_on_see_more(approvable_node) # 'Ver más'

      prerequisite_tree_root_node = prerequisites_tree_page.root
      prerequisite = create_prerequisite_tree(
        prerequisite_tree_root_node,
        approvable_details[:code],
        approvable_details[:is_exam]
      )
      path = File.join(Rails.root, "db", "seeds", "scraped_prerequisites.json")
      save_to path, prerequisite, format: :pretty_json, position: false

      prerequisites_tree_page.back
    end
  end

  private

  def create_prerequisite_tree(original_prerequisite, subject_code = nil, is_exam = false)
    prerequisite_details = prerequisites_tree_page.prerequisite_details(original_prerequisite)

    if subject_code
      prerequisite_details[:subject_code] = subject_code
      prerequisite_details[:is_exam] = is_exam
    end

    prerequisite_details
  end

  def click(xpath_selector, scope = browser)
    find(xpath_selector, scope).click
  end

  def find(xpath_selector, scope = browser)
    scope.find(xpath_selector)
  end

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
end
