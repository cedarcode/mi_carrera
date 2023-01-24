class PrerequisitesTreePage < BedeliasPage
  def root_node
    find("//td[@data-rowkey='root']")
  end

  def back
    click_on 'Volver'
  end

  def extract_subjects_from(node_content)
    subjects = []
    _, *approvables = node_content.split(/(?=\b(?:Examen|Curso|U\.C\.B aprobada)\b)\s*/)

    approvables.each do |approvable|
      needs =
        if approvable.include?("U.C.B aprobada:")
          'all'
        elsif approvable.include?("Examen")
          'exam'
        elsif approvable.include?("Curso")
          'course'
        end
      subject_code = approvable.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
      subjects << { subject_needed: subject_code, needs: needs }
    end

    subjects
  end

  def only_one_approval_needed?(node)
    node.first("div/span[@class='negrita']").text.split(' ')[0] == '1'
  end

  def amount_of_subjects_needed(node)
    node.first("div/span[@class='negrita']").text.split(' ')[0].to_i
  end

  def needs_all_approvals?(node)
    amount_of_subjects_needed(node) == ammount_of_subjects_in_node_content(node_content_from_node(node))
  end

  def ammount_of_subjects_in_node_content(node_content)
    node_content.split('entre: ')[1]
                .enum_for(:scan, /(?=((Examen)|(Curso)|(U\.C\.B aprobada)))/)
                .count
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

  def extract_combinations_from_node(node)
    node_content = node_content_from_node(node)
    subjects = extract_subjects_from(node_content)
    amount_of_subjects_needed = amount_of_subjects_needed(node)
    subjects.combination(amount_of_subjects_needed)
  end

  def prerequisite_type(prerequisite_node)
    node_type = prerequisite_node['data-nodetype']
    node_content = node_content_from_node(prerequisite_node)

    case node_type
    when 'default'
      if node_content.include?('créditos en el Plan:')
        return :credits
      elsif node_content.include?('aprobación') || node_content.include?('actividad')
        if only_one_approval_needed?(prerequisite_node)
          return :any_subject_from_node
        elsif needs_all_approvals?(prerequisite_node)
          return :all_subjects_from_node
        else # 'n' approvals needed out of a list of 'm' subjects when 'n'<'m'
          return :n_subjects_from_node
        end
      elsif node_content.include?('Curso aprobado')
        return :subject_course
      elsif node_content.include?('Examen aprobado')
        return :subject_exam
      elsif node_content.include?('Aprobada')
        return :subject_all
      elsif node_content.include?('Inscripción a Curso')
        return :subject_enrollment
      end
    when 'cag' # 'créditos en el Grupo:'
      return :credits_group
    when 'y'
      return :logical_and_tree
    when 'no'
      return :logical_not_tree
    when 'o'
      return :logical_or_tree
    end
  end

  def prerequisite_tree(prerequisite_node)
    node_content = node_content_from_node(prerequisite_node)
    type = prerequisite_type(prerequisite_node)
    ret = {}

    case type
    when :credits
      ret[:type] = 'credits'
      ret[:credits] = credits_from_node(prerequisite_node)
    when :credits_group
      ret[:type] = 'credits'
      ret[:credits] = credits_from_node(prerequisite_node)
      ret[:group] = group_from_node(prerequisite_node)
    when :all_subjects_from_node
      ret[:type] = 'logical'
      ret[:logical_operator] = 'and'
      ret[:operands] =
        extract_subjects_from(node_content).each_with_object([]) do |s, array|
          array << { type: 'subject', subject_needed: s[:subject_needed], needs: s[:needs] }
        end
    when :any_subject_from_node
      ret[:type] = 'logical'
      ret[:logical_operator] = 'or'
      ret[:operands] =
        extract_subjects_from(node_content).each_with_object([]) do |s, array|
          array << { type: 'subject', subject_needed: s[:subject_needed], needs: s[:needs] }
        end
    when :n_subjects_from_node
      # now we create an OR of ANDs for each combination of subjects
      subject_combinations = extract_combinations_from_node(prerequisite_node)
      ret[:type] = 'logical'
      ret[:logical_operator] = 'or'
      ret[:operands] =
        subject_combinations.to_a.each_with_object([]) do |combination, array|
          array << {
            type: 'logical',
            logical_operator: 'and',
            operands: combination.map do |s|
              { type: 'subject', subject_needed: s[:subject_needed], needs: s[:needs] }
            end
          }
        end
    when :logical_and_tree
      ret[:type] = 'logical'
      ret[:logical_operator] = 'and'
      expand_prerequisites_tree(prerequisite_node)
      ret[:operands] =
        subtrees_roots(prerequisite_node).each_with_object([]) do |subtree_root, array|
          array << prerequisite_tree(subtree_root)
        end
    when :logical_or_tree
      ret[:type] = 'logical'
      ret[:logical_operator] = 'or'
      expand_prerequisites_tree(prerequisite_node)
      ret[:operands] =
        subtrees_roots(prerequisite_node).each_with_object([]) do |subtree_root, array|
          array << prerequisite_tree(subtree_root)
        end
    when :logical_not_tree
      ret[:type] = 'logical'
      ret[:logical_operator] = 'not'
      expand_prerequisites_tree(prerequisite_node)
      ret[:operands] =
        subtrees_roots(prerequisite_node).each_with_object([]) do |subtree_root, array|
          array << prerequisite_tree(subtree_root)
        end
    when :subject_course
      ret[:type] = 'subject'
      ret[:needs] = 'course'
      ret[:subject_needed] = subject_code(node_content)
    when :subject_exam
      ret[:type] = 'subject'
      ret[:needs] = 'exam'
      ret[:subject_needed] = subject_code(node_content)
    when :subject_all
      ret[:type] = 'subject'
      ret[:needs] = 'all'
      ret[:subject_needed] = subject_code(node_content)
    when :subject_enrollment
      ret[:type] = 'subject'
      ret[:needs] = 'enrollment'
      ret[:subject_needed] = subject_code(node_content)
    end

    ret
  end
end
