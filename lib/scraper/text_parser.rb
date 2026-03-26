module Scraper
  module TextParser
    extend self

    # 5265 - CIENCIAS HUMANAS Y SOCIALES - min: 10 créditos
    # I.I - MATEMÁTICA Y CIENCIAS EXPERIMENTALES - min: 50 créditos
    GROUP_CODE_NAME_CREDITS_REGEX = /\A([\w.]+) - (.+) - (?:min): (\d+)(?: créditos)\z/

    # SRN14 - MATEMÁTICA DISCRETA I - créditos: 10
    # FF1-7 - CREDITOS ASIGNADOS POR REVALIDA - créditos: 7
    # FL2.6 - CREDITOS ASIGANDOS POR REVALIDA - créditos: 6
    SUBJECT_CODE_NAME_CREDITS_REGEX = /\A((?:\w|\.|\-)+) - (.+) - (?:créditos): (\d+)(?: programa)?\z/

    # 1324 - PROGRAMACION 4
    SUBJECT_CODE_FROM_NAME_REGEX = /\A(\w+) - .*\z/

    # Title patterns for prerequisite leaf nodes
    APPROVAL_TITLE_REGEX = /\A\d+ (aprobación|actividad)\/es entre:\z/
    CREDITS_TITLE_REGEX = /\A\d+ créditos en el (Grupo|Plan):\z/

    # 15 créditos en el Grupo: 4756 - A.INTEG,TALLERES,PASANT.Y PROY
    CREDITS_CONTENT_REGEX = /\A(\d+) créditos en el (Grupo|Plan): (\w+) - .*\z/

    # 1 aprobación/es entre:
    LOGICAL_LEAF_AMOUNT_REGEX = /\A(\d+) (aprobación|actividad)\/es entre: $/

    # Curso aprobado de la U.C.B: 1324 - PROGRAMACION 4
    # Examen aprobado de la U.C.B: CENURLN - SRN03 - ALGEBRA LINEAL I
    SUBJECT_CONTENT_REGEX = /\A.+: (\w+ - )?(\w+) - (.*)$/

    APPROVABLE_ALL_REGEX = /\AU.C.B aprobada: .+$/
    APPROVABLE_EXAM_REGEX = /\AExamen de la U.C.B: .+$/
    APPROVABLE_COURSE_REGEX = /\ACurso de la U.C.B: .+$/

    LEAF_TITLE_MAPPING = {
      'Curso aprobado de la U.C.B:' => 'course',
      'Examen aprobado de la U.C.B:' => 'exam',
      'Inscripción a Curso de la U.C.B:' => 'course_enrollment',
      'Inscripción a Examen de la U.C.B:' => 'exam_enrollment',
      'U.C.B Aprobada:' => 'all',
      'Actividad Examen aprobada/reprobada en la U.C.B:' => 'exam_activity',
      'Actividad Curso aprobada/reprobada en la U.C.B:' => 'course_activity',
    }

    def parse_group(text)
      code, name, credits = GROUP_CODE_NAME_CREDITS_REGEX.match(text).captures
      { code:, name:, min_credits: credits.to_i }
    end

    def parse_subject(text)
      match = SUBJECT_CODE_NAME_CREDITS_REGEX.match(text)
      return nil unless match

      code, name, credits = match.captures
      { code:, name:, credits: credits.to_i }
    end

    def parse_subject_code_from_name(text)
      SUBJECT_CODE_FROM_NAME_REGEX.match(text).captures[0]
    end

    def parse_leaf(title, content)
      case title
      when APPROVAL_TITLE_REGEX then parse_logical_leaf_prerequisite(content)
      when CREDITS_TITLE_REGEX then parse_credits_prerequisite(content)
      when *LEAF_TITLE_MAPPING.keys then parse_subject_prerequisite(content, LEAF_TITLE_MAPPING[title])
      else raise "Unknown node title: #{title}"
      end
    end

    def parse_credits_prerequisite(content)
      credits, type, group = CREDITS_CONTENT_REGEX.match(content).captures
      { type: 'credits', credits: credits.to_i, group: (group.to_i if type == "Grupo") }.compact
    end

    def parse_subject_prerequisite(content, needs)
      _location, subject_needed_code, subject_needed_name = parse_subject_content(content)
      { type: 'subject', needs:, subject_needed_code:, subject_needed_name: }
    end

    def parse_subject_content(content)
      SUBJECT_CONTENT_REGEX.match(content).captures
    end

    def classify_approvable(line)
      case line
      when APPROVABLE_ALL_REGEX then 'all'
      when APPROVABLE_EXAM_REGEX then 'exam'
      when APPROVABLE_COURSE_REGEX then 'course'
      else raise "Unknown approvable: #{line}"
      end
    end

    def parse_logical_leaf_prerequisite(content)
      amount_of_subjects_needed = LOGICAL_LEAF_AMOUNT_REGEX.match(content).captures[0].to_i
      approvables = content.lines[1..]

      logical_operator = if amount_of_subjects_needed == 1
                           'or'
                         elsif amount_of_subjects_needed == approvables.count
                           'and'
                         else
                           'at_least'
                         end

      operands = approvables.map do |approvable|
        needs = classify_approvable(approvable)
        _location, subject_needed_code, subject_needed_name = parse_subject_content(approvable)
        { type: 'subject', subject_needed_code:, subject_needed_name:, needs: }
      end

      {
        type: 'logical',
        logical_operator:,
        amount_of_subjects_needed: (amount_of_subjects_needed if logical_operator == 'at_least'),
        operands:
      }.compact
    end
  end
end
