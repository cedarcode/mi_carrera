require 'kimurai'
require 'pp'
require 'bedelias_page'
require 'curriculum_page'
require 'prerequisites_page'

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

  def parse_subjects(*_args)
    bedelias_page.visit_curriculum

    subjects = {}

    # get all groups
    curriculum_page.groups.each do |node|
      # for each group, break text into code, name and min_credits
      info = node.text.split(' - ')
      code = info[0]
      name = info[1]
      min_credits = info[2].split(' ')[1].to_i

      puts "Generating subject group #{code} - #{name}"

      # create group and add it to file
      subject_group = { code: code, name: name, min_credits: min_credits }
      path = File.join(Rails.root, "db", "seeds", "scraped_subject_groups.json")
      save_to path, subject_group, format: :pretty_json, position: false

      # for each group, get all subjects
      curriculum_page.subjects(node).each do |subnode|
        # for each subject, break text into code, name and credits
        info = subnode.text.split(' - créditos: ')
        subject_credits = info[1].to_i
        info = info[0].split(' - ')
        subject_code = info[0]
        subject_name = info[1..-1].join(' - ')

        # add the subject to the hash, with code as key
        subjects[subject_code] = {
          code: subject_code,
          name: subject_name,
          credits: subject_credits,
          subject_group: code,
          has_exam: nil
        }
      end
    end

    # got to the prerequisites page
    bedelias_page.visit_prerequisites

    prerequisites_pages do
      # for each page, get all rows
      prerequisites_page.rows_in_current_page.each do |row|
        # for each row (subject)
        index = row['data-ri'].to_i
        column = row.first(:xpath, "td")
        subject_code = column.text.split(' - ')[0]

        if subjects[subject_code].nil?
          puts "Skipping #{column.text}"
          next
        end

        type = column.first(:xpath, "following-sibling::td").text
        page_number = prerequisites_page.current_page_number

        puts "#{page_number}/#{index} Generating #{column.text}, #{type}"

        # save the subject and whether it has an exam
        if type == "Curso"
          subjects[subject_code][:has_exam] = false
        elsif type == "Examen"
          subjects[subject_code][:has_exam] = true
        end
      end
    end

    # save to a file
    path = File.join(Rails.root, "db", "seeds", "scraped_subjects.json")
    subjects.values.each do |subject|
      save_to path, subject, format: :pretty_json, position: false
    end
  end

  def parse_prerequisite(_response, data: {}, **_keyword_arguments)
    bedelias_page.visit_prerequisites

    code = data[:subject_code]
    find("//input[@id='j_idt63:j_idt64:filter']").set(code)
    sleep 1
    click("//tr[@data-ri=0]//a")
    tree = find("//td[@data-rowkey='root']")
    pp create_prerequisite(tree, code)
  end

  def parse_prerequisites(*_args)
    bedelias_page.visit_prerequisites

    prerequisites_pages do
      current_page = prerequisites_page.current_page_number

      prerequisites_rows(current_page) do |row, row_index|
        subject_code = row.first(:xpath, "td[1]").text.split(' - ')[0] # retrieve code from column 'Nombre'
        is_exam = row.first(:xpath, "td[2]").text == "Examen" # from column 'Tipo'

        puts(
          "#{current_page}/#{row_index} - Generating prerequisite for #{subject_code}, #{is_exam ? "exam" : "course"}"
        )

        click("td[3]/a", row) # 'Ver más'

        tree = find("//td[@data-rowkey='root']")
        prerequisite = create_prerequisite(tree, subject_code, is_exam)
        path = File.join(Rails.root, "db", "seeds", "scraped_prerequisites.json")
        save_to path, prerequisite, format: :pretty_json, position: false

        click("//button/span[text()='Volver']")

        # move forward to last selected page on table
        (current_page - 1).times do
          click("//span[contains(@class, 'ui-icon-seek-next')]")
          sleep 0.5
        end
      end
    end
  end

  private

  def extract_subjects_from_box(box)
    subjects = []
    text = box.split('entre: ')[1]

    indices =
      text
      .enum_for(:scan, /(?=((Examen)|(Curso)|(U\.C\.B aprobada)))/)
      .map { Regexp.last_match.offset(0).first } # all indices of 'Exam', 'Curso' and 'U.C.B aprobada'

    (0..(indices.count - 1)).each do |i|
      last = (i == indices.count - 1 ? text.length : indices[i + 1])
      last -= 1
      subject = text[indices[i]..last]

      subject_code = subject.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]

      subject_code = subject_code.tr(' -', '')
      if subject.include?("U.C.B aprobada:")
        needs = 'all'
      elsif subject.include?("Examen")
        needs = 'exam'
      elsif subject.include?("Curso")
        needs = 'course'
      end
      subjects += [{ subject_needed: subject_code, needs: needs }]
    end
    subjects
  end

  def create_prerequisite(original_prerequisite, subject = nil, exam = false)
    prerequisite = {}
    if subject
      prerequisite[:subject] = subject
      prerequisite[:exam] = exam
    end
    node_type = original_prerequisite['data-nodetype']
    node_content = original_prerequisite.first(:xpath, 'div').text

    if node_type == 'default'
      if node_content.include?('créditos en el Plan:')
        prerequisite[:type] = 'credits'
        prerequisite[:credits] = node_content.split(' créditos')[0].to_i
      elsif node_content.include?('aprobación') || node_content.include?('actividad')
        prerequisite[:type] = 'logical'
        if original_prerequisite.first(:xpath, "div/span[@class='negrita']").text.split(' ')[0] == '1'
          prerequisite[:logical_operator] = "or"
        else # change: 'n' approvals needed out of a list of 'm' subjects when 'n'<'m' is not considered
          prerequisite[:logical_operator] = "and"
        end
        prerequisite[:operands] = []
        subjects = extract_subjects_from_box(node_content)

        subjects.each do |s|
          prerequisite[:operands] += [
            { type: 'subject', subject_needed: s[:subject_needed], needs: s[:needs] }
          ]
        end
      elsif node_content.include?('Curso aprobado')
        prerequisite[:type] = 'subject'
        prerequisite[:needs] = 'course'
        prerequisite[:subject_needed] = node_content.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
      elsif node_content.include?('Examen aprobado')
        prerequisite[:type] = 'subject'
        prerequisite[:needs] = 'exam'
        prerequisite[:subject_needed] = node_content.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
      elsif node_content.include?('Aprobada')
        prerequisite[:type] = 'subject'
        prerequisite[:subject_needed] = node_content.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
        prerequisite[:needs] = 'all'
      elsif node_content.include?('Inscripción a Curso')
        prerequisite[:type] = 'subject'
        prerequisite[:subjedt_needed] = node_content.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
        prerequisite[:needs] = 'enrollment'
      end
    elsif node_type == 'cag' # 'créditos en el Grupo:'
      prerequisite[:type] = 'credits'
      prerequisite[:credits] = node_content.split(' créditos')[0].to_i
      prerequisite[:group] = node_content.split('Grupo: ')[1].to_i
    elsif node_type == 'y'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'and'

      toggler = find("div/span[contains(@class, 'ui-tree-toggler')]", original_prerequisite)
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(
        :xpath,
        "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]"
      )
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    elsif node_type == 'no'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'not'

      toggler = find("div/span[contains(@class, 'ui-tree-toggler')]", original_prerequisite)
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(
        :xpath,
        "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]"
      )
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    elsif node_type == 'o'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'or'

      toggler = find("div/span[contains(@class, 'ui-tree-toggler')]", original_prerequisite)
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(
        :xpath,
        "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]"
      )
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    end
    prerequisite
  end

  def prerequisites_pages
    reached_end = false

    while !reached_end do

      yield

      reached_end = prerequisites_page.reached_last_page?

      if !reached_end
        # move forward one page
        prerequisites_page.move_to_next_page
        sleep 0.5

      end
    end
  end

  def prerequisites_rows(page_index)
    row_count = prerequisites_page.row_count_in_page

    row_count.times do |i|
      row_index = (page_index - 1) * ROWS_PER_PAGE + i
      yield(prerequisites_page.row_with_index(row_index), i)
    end
  end

  def click(xpath_selector, scope = browser)
    find(xpath_selector, scope).click
  end

  def find(xpath_selector, scope = browser)
    scope.find(:xpath, xpath_selector)
  end
end
