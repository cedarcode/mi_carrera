class CurriculumPage < BedeliasPage
  def groups
    all("//li[@data-nodetype='Grupo'][not(*//li[@data-nodetype='Grupo'])]/span")
  end

  def subjects(node)
    node.all('..//li[@data-nodetype="Materia"]/span')
  end
end
