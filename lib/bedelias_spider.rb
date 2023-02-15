require 'selenium-webdriver'
require 'capybara'
require 'bedelias_page'
require 'curriculum_page'
require 'prerequisites_page'
require 'prerequisites_tree_page'

class BedeliasSpider
  URL = "https://bedelias.udelar.edu.uy"

  def initialize
    @subject_groups_path = Rails.root.join("db/data/scraped_subject_groups.yml")
    @subjects_path = Rails.root.join("db/data/scraped_subjects.yml")
    @prerequisites_path = Rails.root.join("db/data/scraped_prerequisites.yml")

    headless = ENV["HEADLESS"] == nil || ENV["HEADLESS"] == "true"

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: headless ? %w[headless disable-gpu] : %w[disable-gpu])
      )
    end

    Capybara.configure do |config|
      config.default_driver = :selenium
      config.run_server = false
      config.default_selector = :xpath
      config.save_path = "tmp"
      config.default_max_wait_time = 10
      config.ignore_hidden_elements = false
      config.threadsafe = true
    end

    @browser = Capybara.current_session
    @browser.visit URL
  end

  def parse_subjects_and_prerequisites
    bedelias_page.visit_curriculum

    subjects = {}

    # get all groups
    groups = {}
    curriculum_page.groups.each do |group_node|
      # for each group, get code name min_credits and save it to a json file
      group_details = curriculum_page.group_details(group_node)

      Rails.logger.info "Generating subject group #{group_details[:code]} - #{group_details[:name]}"

      # append group_details to file
      groups[group_details[:code]] = group_details

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
        Rails.logger.info "Warning: skipping #{approvable_details[:code]} - #{approvable_details[:name]}"
        next
      end

      Rails.logger.info(
        "Page #{current_page_number} Generating " +
        "#{approvable_details[:code]} - #{approvable_details[:name]}, #{approvable_details[:type]}"
      )

      # if an exam is found, save that it has an exam
      if approvable_details[:type] == "Examen"
        subjects[approvable_details[:code]][:has_exam] = true
      end
    end

    # now the prerequisites
    prerequisites_page.move_to_first_page

    prerequisites = []
    prerequisites_page.for_each_approvable do |approvable_node, current_page_number|
      approvable_details = prerequisites_page.approvable_details(approvable_node)

      Rails.logger.info(
        "Page #{current_page_number} - Generating prerequisite for " +
        "#{approvable_details[:code]}, #{approvable_details[:is_exam] ? "exam" : "course"}"
      )

      prerequisites_page.click_on_see_more(approvable_node) # 'Ver más'

      prerequisite_tree_root_node = prerequisites_tree_page.root_node
      prerequisite = create_prerequisite_tree(
        prerequisite_tree_root_node,
        approvable_details[:code],
        approvable_details[:is_exam]
      )

      prerequisites << prerequisite

      prerequisites_tree_page.back
    end

    prerequisites.each do |prerequisite_tree|
      add_missing_exams_and_subjects(prerequisite_tree, subjects)
    end

    File.open(subject_groups_path, "w") do |file|
      file.write groups.deep_stringify_keys.to_yaml
    end

    subjects = YAML.load(File.read(subjects_path)).to_h.deep_merge(subjects.deep_stringify_keys)

    # save to a file
    File.open(subjects_path, "w") do |file|
      file.write subjects.to_yaml
    end

    File.open(prerequisites_path, "w") do |file|
      data = { prerequisites: prerequisites }
      file.write data.deep_stringify_keys.to_yaml
    end
  end

  private

  attr_reader :browser, :subject_groups_path, :subjects_path, :prerequisites_path

  def add_missing_exams_and_subjects(prerequisite_tree, subjects)
    # Check in the prereequisite tree if we have subject prerequisites
    # that point to a subject or an exam that we didn't scrape.
    # This can happen because the subject doesn't show up in the
    # curriculum page or the exam doesn't show up in the prerequisites
    # page.

    if prerequisite_tree[:type] == 'subject' && prerequisite_tree[:needs] == 'exam'
      if subjects[prerequisite_tree[:subject_needed_code]]
        subjects[prerequisite_tree[:subject_needed_code]][:has_exam] = true
      else
        subjects[prerequisite_tree[:subject_needed_code]] =
          {
            code: prerequisite_tree[:subject_needed_code],
            name: prerequisite_tree[:subject_needed_name],
            credits: 0,
            has_exam: prerequisite_tree[:needs] == 'exam',
            eva_link: nil,
            openfing_link: nil
          }
      end
    elsif prerequisite_tree[:type] == 'logical'
      prerequisite_tree[:operands].each do |operand|
        add_missing_exams_and_subjects(operand, subjects)
      end
    end
  end

  def create_prerequisite_tree(original_prerequisite, subject_code = nil, is_exam = false)
    prerequisite_tree = prerequisites_tree_page.prerequisite_tree(original_prerequisite)

    if subject_code
      prerequisite_tree[:subject_code] = subject_code
      prerequisite_tree[:is_exam] = is_exam
    end

    prerequisite_tree
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
