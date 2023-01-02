class CurriculumPage < BedeliasPage
  def groups
    all("//li[@data-nodetype='Grupo'][not(*//li[@data-nodetype='Grupo'])]/span")
  end

  def subjects_in_group(group_node)
    group_node.all('..//li[@data-nodetype="Materia"]/span')
  end

  def group_details(group)
    info = group.text.split(' - ')

    {
      code: info[0],
      name: info[1],
      min_credits: info[2].split(' ')[1].to_i
    }
  end

  def subject_details(subject)
    info = subject.text.split(' - créditos: ')
    subject_credits = info[1].to_i
    info = info[0].split(' - ')
    subject_code = info[0]
    subject_name = info[1..-1].join(' - ')

    {
      code: subject_code,
      name: subject_name,
      credits: subject_credits,
      has_exam: nil
    }
  end

  def subject_row_details(subject_row)
    index = subject_row['data-ri'].to_i
    column = subject_row.first(:xpath, "td")
    subject_code = column.text.split(' - ')[0]
    type = column.first(:xpath, "following-sibling::td").text
    is_exam = subject_row.first(:xpath, "td[2]").text == "Examen" # from column 'Tipo'

    {
      index: index,
      subject_code: subject_code,
      type: type,
      subject_name: column.text,
      is_exam: is_exam
    }
  end
end
