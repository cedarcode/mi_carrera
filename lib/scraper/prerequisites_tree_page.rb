module Scraper
  module PrerequisitesTreePage
    extend self

    NODE_TYPE_MAPPING = {
      'y' => 'and', # debe tener todas
      'no' => 'not', # no debe tener
      'o' => 'or' # debe tener alguna
    }

    def prerequisite_tree(node)
      case node['data-nodetype']
      when *NODE_TYPE_MAPPING.keys then process_branch(node)
      when 'default', 'cag' then process_leaf(node)
      else raise "Unknown node_type: #{node['data-nodetype']}"
      end
    end

    private

    def process_branch(node)
      node.find('.ui-tree-toggler').click unless node[:class].include?('ui-treenode-expanded')
      children = node.sibling('.ui-treenode-children-container').all('.ui-treenode')
      operands = children.map { |child| prerequisite_tree(child) }
      { type: 'logical', logical_operator: NODE_TYPE_MAPPING[node['data-nodetype']], operands: }
    end

    def process_leaf(node)
      title = node.find('.negrita').text
      content = node.find('.ui-treenode-content').text

      case title
      # 1 aprobación/es entre: Curso de la U.C.B: 1511 - SISTEMAS OPERATIVOS ...
      when /\A\d+ (aprobación|actividad)\/es entre:\z/ then logical_leaf_prerequisite(content)
      # 15 créditos en el Grupo: 4756 - A.INTEG,TALLERES,PASANT.Y PROY
      # 380 créditos en el Plan: 1997 - INGENIERIA EN COMPUTACION
      when /\A\d+ créditos en el (Grupo|Plan):\z/ then credits_prerequisite(content)
      # Curso aprobado de la U.C.B: 1324 - PROGRAMACION 4
      when 'Curso aprobado de la U.C.B:' then subject_prerequisite(content, 'course')
      # Examen aprobado de la U.C.B: CENURLN - SRN03 - ALGEBRA LINEAL I
      when 'Examen aprobado de la U.C.B:' then subject_prerequisite(content, 'exam')
      # Inscripción a Curso de la U.C.B: 1445 - TALLER DE ARQUITECTURA DE COMPUTADORAS
      when 'Inscripción a Curso de la U.C.B:' then subject_prerequisite(content, 'course_enrollment')
      # Inscripción a Examen de la U.C.B: GAL1P - GEOMETRIA Y ALGEBRA LINEAL 1 INTERACTIVA
      when 'Inscripción a Examen de la U.C.B:' then subject_prerequisite(content, 'exam_enrollment')
      # U.C.B Aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1
      when 'U.C.B Aprobada:' then subject_prerequisite(content, 'all')
      # Actividad Examen aprobada/reprobada en la U.C.B: 1151 - FISICA 1
      when 'Actividad Examen aprobada/reprobada en la U.C.B:' then subject_prerequisite(content, 'exam_activity')
      # Actividad Curso aprobada/reprobada en la U.C.B: 1030 - GEOMETRIA Y ALGEBRA LINEAL 1
      when 'Actividad Curso aprobada/reprobada en la U.C.B:' then subject_prerequisite(content, 'course_activity')
      else raise "Unknown node title: #{title}"
      end
    end

    def subject_prerequisite(content, needs)
      _location, subject_needed_code, subject_needed_name = parse_subject(content)
      { type: 'subject', needs:, subject_needed_code:, subject_needed_name: }
    end

    def credits_prerequisite(content)
      credits, type, group = /\A(\d+) créditos en el (Grupo|Plan): (\d+) - .*\z/.match(content).captures
      { type: 'credits', credits: credits.to_i, group: (group.to_i if type == "Grupo") }.compact
    end

    def logical_leaf_prerequisite(content)
      amount_of_subjects_needed = /\A(\d+) (aprobación|actividad)\/es entre: $/.match(content).captures[0].to_i
      approvables = content.lines[1..]

      logical_operator = if amount_of_subjects_needed == 1
                           'or'
                         elsif amount_of_subjects_needed == approvables.count
                           'and'
                         else
                           'at_least'
                         end

      operands = approvables.map do |approvable|
        needs = case approvable
                when /\AU.C.B aprobada: .+$/ then 'all'
                when /\AExamen de la U.C.B: .+$/ then 'exam'
                when /\ACurso de la U.C.B: .+$/ then 'course'
                else raise "Unknown approvable: #{approvable}"
                end

        _location, subject_needed_code, subject_needed_name = parse_subject(approvable)
        { type: 'subject', subject_needed_code:, subject_needed_name:, needs: }
      end

      {
        type: 'logical',
        logical_operator:,
        amount_of_subjects_needed: (amount_of_subjects_needed if logical_operator == 'at_least'),
        operands:
      }.compact
    end

    # Curso aprobado de la U.C.B: 1324 - PROGRAMACION 4
    # Examen aprobado de la U.C.B: CENURLN - SRN03 - ALGEBRA LINEAL I
    # Inscripción a Curso de la U.C.B: 1445 - TALLER DE ARQUITECTURA DE COMPUTADORAS
    # U.C.B Aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1
    # Examen de la U.C.B: 1453 - COMPL.ARQUITECTURA DE COMPUTADORAS
    def parse_subject(content) = /\A.+: (\w+ - )?(\w+) - (.*)$/.match(content).captures
  end
end
