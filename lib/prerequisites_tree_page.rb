class PrerequisitesTreePage < BedeliasPage
  def root
    find("//td[@data-rowkey='root']")
  end

  def back
    click_on 'Volver'
  end

  def extract_subjects_from(box)
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

  def only_one_approval_needed?(node)
    node.first("div/span[@class='negrita']").text.split(' ')[0] == '1'
  end

  def subject_code(node)
    node.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
  end

  def expand_prerequisites_tree(node)
    toggler = node.find("div/span[contains(@class, 'ui-tree-toggler')]")
    if toggler[:class].include?('plus')
      toggler.click
    end
  end

  def subtrees_roots(node)
    node.all("following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]")
  end

  def node_content_from_node(node)
    node.first('div').text
  end

  def credits_from_node(node)
    node_content_from_node(node).split(' créditos')[0].to_i
  end

  def group_from_node(node)
    node_content_from_node(node).split('Grupo: ')[1].to_i
  end
end
