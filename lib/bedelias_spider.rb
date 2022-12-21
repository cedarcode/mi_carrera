require 'kimurai'
require 'pp'

class BedeliasSpider < Kimurai::Base
  @name = "bedelias_spider"
  @engine = :selenium_chrome

  ROWS_PER_PAGE = 20

  def parse_subjects(*_args)
    visit_curriculum

    subjects = {}

    browser.all("//li[@data-nodetype='Grupo'][not(*//li[@data-nodetype='Grupo'])]/span").each do |node|
      info = node.text.split(' - ')
      code = info[0]
      name = info[1]
      min_credits = info[2].split(' ')[1].to_i

      puts "Generating subject group #{code} - #{name}"

      subject_group = { code: code, name: name, min_credits: min_credits }
      path = File.join(Rails.root, "db", "seeds", "scraped_subject_groups.json")
      save_to path, subject_group, format: :pretty_json, position: false

      node.all('..//li[@data-nodetype="Materia"]/span').each do |subnode|
        info = subnode.text.split(' - créditos: ')
        subject_credits = info[1].to_i
        info = info[0].split(' - ')
        subject_code = info[0]
        subject_name = info[1..-1].join(' - ')

        subjects[subject_code] = {
          code: subject_code,
          name: subject_name,
          credits: subject_credits,
          subject_group: code,
          has_exam: nil
        }
      end
    end

    visit_prerequisites

    prerequisites_pages do |page_number|
      prerequisites_rows(page_number) do |row, index|
        column = row.first(:xpath, "td")
        subject_code = column.text.split(' - ')[0]

        if subjects[subject_code].nil?
          puts "Skipping #{column.text}"
          next
        end

        type = column.first(:xpath, "following-sibling::td").text

        puts "#{page_number}/#{index} Generating #{column.text}, #{type}"

        if type == "Curso"
          subjects[subject_code][:has_exam] = false
        elsif type == "Examen"
          subjects[subject_code][:has_exam] = true
        end
      end
    end

    path = File.join(Rails.root, "db", "seeds", "scraped_subjects.json")
    subjects.values.each do |subject|
      save_to path, subject, format: :pretty_json, position: false
    end
  end

  def parse_prerequisite(_response, data: {}, **_keyword_arguments)
    visit_curriculum
    visit_prerequisites

    code = data[:subject_code]
    find("//input[@id='j_idt63:j_idt64:filter']").set(code)
    sleep 1
    click("//tr[@data-ri=0]//a")
    tree = find("//td[@data-rowkey='root']")
    pp create_prerequisite(tree, code)
  end

  def parse_prerequisites(*_args)
    visit_curriculum
    visit_prerequisites

    prerequisites_pages do |current_page|
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
      subject_code = subject.match(/\ [\d[A-Z]]* -/)[0]
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
        prerequisite[:subject_needed] = node_content.match(/\ [\d[A-Z]]* -/)[0].tr(' -', '')
      elsif node_content.include?('Examen aprobado')
        prerequisite[:type] = 'subject'
        prerequisite[:needs] = 'exam'
        prerequisite[:subject_needed] = node_content.match(/\ [\d[A-Z]]* -/)[0].tr(' -', '')
      elsif node_content.include?('Aprobada')
        prerequisite[:type] = 'subject'
        prerequisite[:subject_needed] = node_content.match(/\ [\d[A-Z]]* -/)[0].tr(' -', '')
        prerequisite[:needs] = 'all'
      elsif node_content.include?('Inscripción a Curso')
        prerequisite[:type] = 'subject'
        prerequisite[:subjedt_needed] = node_content.match(/\ [\d[A-Z]]* -/)[0].tr(' -', '')
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

  def visit_curriculum
    click("//a[text()='PLANES DE ESTUDIO']")

    click("//a[@id='j_idt52:j_idt56:1:j_idt58']")

    click("//h3[text()='TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA']")
    click("//tr//span[text()='FING - FACULTAD DE INGENIERÍA']")

    sleep 2
    click("//td[text()='INGENIERIA EN COMPUTACION']/preceding-sibling::td/div")
    click("//a[@id='datos1111:j_idt92:35:j_idt104:0:verComposicionPlan']")
  end

  def visit_prerequisites
    find("//button[span[text()='Sistema de previaturas']]").click
  end

  def click(xpath_selector, scope = browser)
    find(xpath_selector, scope).click
  end

  def find(xpath_selector, scope = browser)
    scope.find(:xpath, xpath_selector)
  end

  def prerequisites_pages
    reached_end = false
    current_page = 1

    while !reached_end do
      yield(current_page)

      reached_end = find("//span[contains(@class, 'ui-paginator-next')]")[:class].include?('disabled')

      if !reached_end
        # move forward one page
        click("//span[contains(@class, 'ui-icon-seek-next')]")
        sleep 0.5
        current_page += 1
      end
    end
  end

  def prerequisites_rows(page_index)
    row_count = browser.all(:xpath, "//tr[@data-ri]").count

    row_count.times do |i|
      row_index = (page_index - 1) * ROWS_PER_PAGE + i
      row = find("//tr[@data-ri=#{row_index}]")

      yield(row, i)
    end
  end
end
