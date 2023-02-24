class PrerequisitesTreePage < BedeliasPage
  def root_node
    find("//td[@data-rowkey='root']")
  end

  def back
    click_on 'Volver'
  end

  def prerequisite_tree(prerequisite_node)
    type = prerequisite_type(prerequisite_node)

    case type
    when :credits
      credits_prerequisite_details(prerequisite_node)
    when :credits_group
      credits_prerequisite_details(prerequisite_node, group: true)
    when :all_subjects_from_node
      logical_prerequisite_leaf_node_details(prerequisite_node, operator: 'and')
    when :any_subject_from_node
      logical_prerequisite_leaf_node_details(prerequisite_node, operator: 'or')
    when :n_subjects_from_node
      logical_prerequisite_leaf_node_details(prerequisite_node, operator: 'at_least')
    when :logical_and_tree
      logical_prerequisite_branch_node_details(prerequisite_node, operator: 'and')
    when :logical_or_tree
      logical_prerequisite_branch_node_details(prerequisite_node, operator: 'or')
    when :logical_not_tree
      logical_prerequisite_branch_node_details(prerequisite_node, operator: 'not')
    when :subject_course
      subject_prerequisite_node_details(prerequisite_node, variant: 'course')
    when :subject_exam
      subject_prerequisite_node_details(prerequisite_node, variant: 'exam')
    when :subject_all
      subject_prerequisite_node_details(prerequisite_node, variant: 'all')
    when :subject_enrollment
      subject_prerequisite_node_details(prerequisite_node, variant: 'enrollment')
    end
  end

  private

  def node_content_from_node(node)
    node.first('div').text
  end

  def prerequisite_type(prerequisite_node)
    node_type = prerequisite_node['data-nodetype']
    node_content = node_content_from_node(prerequisite_node)

    case node_type
    when 'default'
      if node_content.include?('créditos en el Plan:')
        :credits
      elsif node_content.include?('aprobación') || node_content.include?('actividad')
        if only_one_approval_needed?(prerequisite_node)
          :any_subject_from_node
        elsif needs_all_approvals?(prerequisite_node)
          :all_subjects_from_node
        else # 'n' approvals needed out of a list of 'm' subjects when 'n'<'m'
          :n_subjects_from_node
        end
      elsif node_content.include?('Curso aprobado')
        :subject_course
      elsif node_content.include?('Examen aprobado')
        :subject_exam
      elsif node_content.include?('Aprobada')
        :subject_all
      elsif node_content.include?('Inscripción a Curso')
        :subject_enrollment
      end
    when 'cag' # 'créditos en el Grupo:'
      :credits_group
    when 'y'
      :logical_and_tree
    when 'no'
      :logical_not_tree
    when 'o'
      :logical_or_tree
    end
  end

  def credits_prerequisite_details(prerequisite_node, group: false)
    {
      type: 'credits',
      credits: node_content_from_node(prerequisite_node).split(' créditos')[0].to_i,
    }.merge!(group ? { group: node_content_from_node(prerequisite_node).split('Grupo: ')[1].to_i } : {})
  end

  def logical_prerequisite_leaf_node_details(prerequisite_node, operator:)
    operands =
      extract_subjects_from_logical_prerequisite_leaf_node(prerequisite_node).each_with_object([]) do |subject, array|
        array << {
          type: 'subject',
          subject_needed_code: subject[:subject_needed_code],
          subject_needed_name: subject[:subject_needed_name],
          needs: subject[:needs],
        }
      end

    details = {}
    details[:type] = 'logical'
    details[:logical_operator] = operator
    details[:amount_of_subjects_needed] = amount_of_subjects_needed(prerequisite_node) if operator == 'at_least'
    details[:operands] = operands

    details
  end

  def logical_prerequisite_branch_node_details(prerequisite_node, operator:)
    expand_prerequisites_tree(prerequisite_node)
    child_nodes = prerequisite_node.all(
      "following-sibling::td/div/table/tbody/tr/td[contains(@class, 'ui-treenode ')]",
      visible: false
    )
    operands =
      child_nodes.each_with_object([]) do |child_node, array|
        array << prerequisite_tree(child_node)
      end

    {
      type: 'logical',
      logical_operator: operator,
      operands: operands,
    }
  end

  def subject_prerequisite_node_details(prerequisite_node, variant:)
    {
      type: 'subject',
      needs: variant,
      subject_needed_code: subject_code(node_content_from_node(prerequisite_node)),
      subject_needed_name: subject_name(node_content_from_node(prerequisite_node)),
    }
  end

  def extract_subjects_from_logical_prerequisite_leaf_node(prerequisite_node)
    node_content = node_content_from_node(prerequisite_node)
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

      subjects << {
        subject_needed_code: subject_code(approvable),
        subject_needed_name: subject_name(approvable),
        needs: needs,
      }
    end

    subjects
  end

  def only_one_approval_needed?(node)
    amount_of_subjects_needed(node) == 1
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

  def subject_code(approvable_text)
    approvable_text.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]
  end

  def subject_name(approvable_text)
    approvable_text.split('- ', 2).last.strip
  end

  def expand_prerequisites_tree(node)
    toggler = node.find("div/span[contains(@class, 'ui-tree-toggler')]")
    if toggler[:class].include?('plus')
      toggler.click
    end
  end
end
