require 'kimurai'
require 'pp'

class BedeliasSpider < Kimurai::Base
  @name = "bedelias_spider"
  @engine = :selenium_chrome
  @start_urls = ['https://bedelias.udelar.edu.uy']
  @config = {}

  def parse_subjects(_response, url:, data: {})
    browser.click_button 'Menu'
    browser.find(:xpath, "//a[span[text() = 'Planes de estudio / Previas']]").click

    browser.find(:xpath, "//h3[text()='TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA']").click
    browser.find(:xpath, "//tr//span[text()='FING - FACULTAD DE INGENIERÍA']").click

    sleep 2
    browser.find(:xpath, "//td[text()='INGENIERIA EN COMPUTACION']/preceding-sibling::td/div").click
    browser.find(:xpath, "//a[@id='datos1111:j_idt58:31:j_idt70:0:verComposicionPlan']").click

    subjects = {}

    # change: subjects from "MATERIAS OPCIONALES" aren't scraped because there isn't a group inside the group
    browser.all('//li[@data-nodetype="Grupo"]//li[@data-nodetype="Grupo"]/span').each do |node|
      info = node.text.split(' - ')
      code = info[0]
      name = info[1]
      min_credits = info[2].split(' ')[1].to_i
      subject_group = { code: code, name: name, min_credits: min_credits }
      path = File.join(Rails.root, "db", "seeds", "scraped_subject_groups.json")
      save_to path, subject_group, format: :pretty_json, position: false

      node.all('..//li[@data-nodetype="Materia"]/span').each do |subnode|
        info = subnode.text.split(' - ')
        subject_code = info[0]
        subject_name = info[1]
        subject_credits = info[2][9..-1]
        group = code
        subjects[subject_code] = { code: subject_code, name: subject_name, credits: subject_credits, subject_group: code, has_exam: false }
      end
    end

    browser.find(:xpath, "//button[span[text()='Sistema de previaturas']]").click

    next_page = browser.find(:xpath, "//span[contains(@class, 'ui-icon-seek-next')]")
    reached_end = false
    while !reached_end do
      browser.all(:xpath, "//tbody[@id='j_idt63_data']/tr").each do |row|
        column = row.first(:xpath, "td")
        subject_code = column.text.split(' - ')[0]
        type = column.first(:xpath, "following-sibling::td").text

        puts "Generating " + column.text + ", " + type

        if subjects[subject_code] # tmp: avoid conflict with unscraped subjects from "MATERIAS OPCIONALES"
          if type == "Examen"
            subjects[subject_code][:has_exam] = true
          end
        else
          subjects[subject_code] = { code: subject_code, name: column.text.split(' - ')[1], missing_info: true }
        end
        # save only one entry of each subject to avoid duplicates
        # change: the condition slows things down a lot, find another way to check for another entry for the same subject
        if row.all(:xpath, "following-sibling::tr/td[1][contains(text()," + subject_code + ")]").count == 0
          path = File.join(Rails.root, "db", "seeds", "scraped_subjects.json")
          save_to path, subjects[subject_code], format: :pretty_json, position: false
        end
      end
      reached_end = next_page.find(:xpath, '..')[:class].include?('disabled') ? true : false
      next_page.click
      sleep 1
    end
  end

  def parse_prerequisite(_response, url:, data: {})
    browser.click_button 'Menu'
    browser.find(:xpath, "//a[span[text() = 'Planes de estudio / Previas']]").click

    browser.find(:xpath, "//h3[text()='TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA']").click
    browser.find(:xpath, "//tr//span[text()='FING - FACULTAD DE INGENIERÍA']").click

    sleep 2
    browser.find(:xpath, "//td[text()='INGENIERIA EN COMPUTACION']/preceding-sibling::td/div").click
    browser.find(:xpath, "//a[@id='datos1111:j_idt58:31:j_idt70:0:verComposicionPlan']").click

    browser.find(:xpath, "//button[span[text()='Sistema de previaturas']]").click

    code = data[:subject_code]
    browser.find(:xpath, "//input[@id='j_idt63:j_idt64:filter']").set(code)
    sleep 1
    browser.find(:xpath, "//tr[@data-ri=0]//a").click
    tree = browser.find(:xpath, "//td[@data-rowkey='root']")
    pp create_prerequisite(tree, code)
  end

  def parse_prerequisites(_response, url:, data: {})
    browser.click_button 'Menu'
    browser.find(:xpath, "//a[span[text() = 'Planes de estudio / Previas']]").click

    browser.find(:xpath, "//h3[text()='TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA']").click
    browser.find(:xpath, "//tr//span[text()='FING - FACULTAD DE INGENIERÍA']").click

    sleep 2
    browser.find(:xpath, "//td[text()='INGENIERIA EN COMPUTACION']/preceding-sibling::td/div").click
    browser.find(:xpath, "//a[@id='datos1111:j_idt58:31:j_idt70:0:verComposicionPlan']").click

    browser.find(:xpath, "//button[span[text()='Sistema de previaturas']]").click

    reached_end = false
    already_scraped = 0
    current_page = 1
    selected_page = 1
    while !reached_end do
      row_count = browser.all(:xpath, "//tr[@data-ri]").count
      (1..row_count).each do
        row = browser.find(:xpath, "//tr[@data-ri=" + already_scraped.to_s + "]")
        subject_code = row.first(:xpath, "td[1]").text().split(' - ')[0] # retrieve code from column 'Nombre'
        is_exam = row.first(:xpath, "td[2]").text() == "Examen" # from column 'Tipo'

        puts (already_scraped + 1).to_s + " - Generating prerequisite for " + subject_code + ", " + (is_exam ? "exam" : "course")

        row.find(:xpath, "td[3]/a").click # 'Ver más'

        tree = browser.find(:xpath, "//td[@data-rowkey='root']")
        prerequisite = create_prerequisite(tree, subject_code, is_exam)
        path = File.join(Rails.root, "db", "seeds", "scraped_prerequisites.json")
        save_to path, prerequisite, format: :pretty_json, position: false
        already_scraped += 1

        back = browser.find(:xpath, "//button/span[text()='Volver']")
        back.click
        selected_page = 1 # table paginator goes back to first page

        # move forward to last selected page on table
        while current_page != selected_page do
          next_page = browser.find(:xpath, "//span[contains(@class, 'ui-icon-seek-next')]")
          next_page.click
          selected_page += 1
          sleep 0.5
        end
      end
      reached_end = browser.find(:xpath, "//span[contains(@class, 'ui-paginator-next')]")[:class].include?('disabled') ? true : false
      if !reached_end
        # move forward one page
        next_page = browser.find(:xpath, "//span[contains(@class, 'ui-icon-seek-next')]")
        next_page.click
        sleep 0.5
        current_page += 1
      end
    end
  end

  private

  def extract_subjects_from_box(box)
    subjects = []
    text = box.split('entre: ')[1]
    indices = text.enum_for(:scan, /(?=((Examen)|(Curso)|(U\.C\.B aprobada)))/).map { Regexp.last_match.offset(0).first } # all indices of 'Exam', 'Curso' and 'U.C.B aprobada'
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

  def create_prerequisite(original_prerequisite, subject = nil, exam = false) # prerequisite must be <td> with attribute @data-rowkey and @data-nodetype
    prerequisite = {}
    if subject
      prerequisite[:subject] = subject
      prerequisite[:exam] = exam
    end
    node_type = original_prerequisite['data-nodetype']
    node_content = original_prerequisite.first(:xpath, 'div').text()

    if node_type == 'default'
      if node_content.include?('créditos en el Plan:')
        prerequisite[:type] = 'credits'
        prerequisite[:credits] = node_content.split(' créditos')[0].to_i
      elsif node_content.include?('aprobación')
        prerequisite[:type] = 'logical'
        if original_prerequisite.first(:xpath, "div/span[@class='negrita']").text().split(' ')[0] == '1'
          prerequisite[:logical_operator] = "OR"
        else # change: 'n' approvals needed out of a list of 'm' subjects when 'n'<'m' is not considered
          prerequisite[:logical_operator] = "AND"
        end
        prerequisite[:operands] = []
        subjects = extract_subjects_from_box(node_content)
        subjects.each do |subject|
          prerequisite[:operands] += [{ type: 'subject', subject_needed: subject[:subject_needed], needs: subject[:needs] }]
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
      end
    elsif node_type == 'cag' # 'créditos en el Grupo:'
      prerequisite[:type] = 'credits'
      prerequisite[:credits] = node_content.split(' créditos')[0].to_i
      prerequisite[:group] = node_content.split('Grupo: ')[1].to_i
    elsif node_type == 'y'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'AND'

      toggler = original_prerequisite.first(:xpath, "div/span[contains(@class, 'ui-tree-toggler')]")
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(:xpath, "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]")
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    elsif node_type == 'no'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'NOT'

      toggler = original_prerequisite.first(:xpath, "div/span[contains(@class, 'ui-tree-toggler')]")
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(:xpath, "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]")
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    elsif node_type == 'o'
      prerequisite[:type] = 'logical'
      prerequisite[:logical_operator] = 'OR'

      toggler = original_prerequisite.first(:xpath, "div/span[contains(@class, 'ui-tree-toggler')]")
      if toggler[:class].include?('plus')
        toggler.click
      end
      prerequisite[:operands] = []
      operands = original_prerequisite.all(:xpath, "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]")
      operands.each do |operand|
        prerequisite[:operands] += [create_prerequisite(operand)]
      end
    end
    prerequisite
  end
end
