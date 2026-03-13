require 'rails_helper'
require 'scraper/text_parser'

RSpec.describe Scraper::TextParser, type: :lib do
  describe '.parse_group' do
    it 'parses a numeric group code' do
      result = described_class.parse_group('5265 - CIENCIAS HUMANAS Y SOCIALES - min: 10 créditos')

      expect(result).to eq(code: '5265', name: 'CIENCIAS HUMANAS Y SOCIALES', min_credits: 10)
    end

    it 'parses a group with dotted code' do
      text = 'I.I - MATEMÁTICA Y CIENCIAS EXPERIMENTALES - min: 50 créditos'
      result = described_class.parse_group(text)

      expect(result).to eq(code: 'I.I', name: 'MATEMÁTICA Y CIENCIAS EXPERIMENTALES', min_credits: 50)
    end

    it 'parses a group with zero min credits' do
      result = described_class.parse_group('4882 - INT.ARTIFICIAL Y ROBOTICA - min: 0 créditos')

      expect(result).to eq(code: '4882', name: 'INT.ARTIFICIAL Y ROBOTICA', min_credits: 0)
    end

    it 'parses a group with abbreviations and special chars in name' do
      text = '4428 - ARQUIT, S.OP. Y REDES DE COMP. - min: 30 créditos'
      result = described_class.parse_group(text)

      expect(result).to eq(code: '4428', name: 'ARQUIT, S.OP. Y REDES DE COMP.', min_credits: 30)
    end
  end

  describe '.parse_subject' do
    it 'parses a standard subject' do
      result = described_class.parse_subject('1010 - LOGICA Y COMPUTACION - créditos: 12')

      expect(result).to eq(code: '1010', name: 'LOGICA Y COMPUTACION', credits: 12)
    end

    it 'parses a subject with alphanumeric code' do
      result = described_class.parse_subject('SRN14 - MATEMÁTICA DISCRETA I - créditos: 10')

      expect(result).to eq(code: 'SRN14', name: 'MATEMÁTICA DISCRETA I', credits: 10)
    end

    it 'parses a subject with hyphen in code' do
      text = 'FF1-7 - CREDITOS ASIGNADOS POR REVALIDA - créditos: 7'
      result = described_class.parse_subject(text)

      expect(result).to eq(code: 'FF1-7', name: 'CREDITOS ASIGNADOS POR REVALIDA', credits: 7)
    end

    it 'parses a subject with dot in code' do
      text = 'FL2.6 - CREDITOS ASIGANDOS POR REVALIDA - créditos: 6'
      result = described_class.parse_subject(text)

      expect(result).to eq(code: 'FL2.6', name: 'CREDITOS ASIGANDOS POR REVALIDA', credits: 6)
    end

    it 'parses a subject with "programa" suffix' do
      text = '1271 - CIUDADANIA EN ENTORNOS DIGITALES - créditos: 8 programa'
      result = described_class.parse_subject(text)

      expect(result).to eq(code: '1271', name: 'CIUDADANIA EN ENTORNOS DIGITALES', credits: 8)
    end

    it 'parses a subject with accented characters in name' do
      result = described_class.parse_subject('IE - INTRODUCCIÓN A LA ECONOMÍA - créditos: 10')

      expect(result).to eq(code: 'IE', name: 'INTRODUCCIÓN A LA ECONOMÍA', credits: 10)
    end

    it 'parses a subject with parentheses in name' do
      text = '24CIA - COMUNICACIÓN E INTELIGENCIA ARTIFICIAL (PPP) - créditos: 9'
      result = described_class.parse_subject(text)

      expect(result).to eq(
        code: '24CIA', name: 'COMUNICACIÓN E INTELIGENCIA ARTIFICIAL (PPP)', credits: 9
      )
    end

    it 'returns nil for non-matching text' do
      expect(described_class.parse_subject('some random text')).to be_nil
    end
  end

  describe '.parse_subject_code_from_name' do
    it 'extracts a numeric code' do
      expect(described_class.parse_subject_code_from_name('1324 - PROGRAMACION 4')).to eq('1324')
    end

    it 'extracts an alphanumeric code' do
      expect(described_class.parse_subject_code_from_name('SRN03 - ALGEBRA LINEAL I')).to eq('SRN03')
    end
  end

  describe '.parse_leaf' do
    context 'with subject prerequisite titles' do
      it 'parses "Curso aprobado de la U.C.B:" title' do
        result = described_class.parse_leaf(
          'Curso aprobado de la U.C.B:',
          'Curso aprobado de la U.C.B: 1324 - PROGRAMACION 4'
        )

        expect(result).to eq(
          type: 'subject', needs: 'course',
          subject_needed_code: '1324', subject_needed_name: 'PROGRAMACION 4'
        )
      end

      it 'parses "Examen aprobado de la U.C.B:" title with location prefix' do
        result = described_class.parse_leaf(
          'Examen aprobado de la U.C.B:',
          'Examen aprobado de la U.C.B: CENURLN - SRN03 - ALGEBRA LINEAL I'
        )

        expect(result).to eq(
          type: 'subject', needs: 'exam',
          subject_needed_code: 'SRN03', subject_needed_name: 'ALGEBRA LINEAL I'
        )
      end

      it 'parses "Inscripción a Curso de la U.C.B:" title' do
        content = 'Inscripción a Curso de la U.C.B: 1445 - TALLER DE ARQUITECTURA DE COMPUTADORAS'
        result = described_class.parse_leaf('Inscripción a Curso de la U.C.B:', content)

        expect(result).to eq(
          type: 'subject', needs: 'course_enrollment',
          subject_needed_code: '1445',
          subject_needed_name: 'TALLER DE ARQUITECTURA DE COMPUTADORAS'
        )
      end

      it 'parses "Inscripción a Examen de la U.C.B:" title' do
        content = 'Inscripción a Examen de la U.C.B: GAL1P - GEOMETRIA Y ALGEBRA LINEAL 1 INTERACTIVA'
        result = described_class.parse_leaf('Inscripción a Examen de la U.C.B:', content)

        expect(result).to eq(
          type: 'subject', needs: 'exam_enrollment',
          subject_needed_code: 'GAL1P',
          subject_needed_name: 'GEOMETRIA Y ALGEBRA LINEAL 1 INTERACTIVA'
        )
      end

      it 'parses "U.C.B Aprobada:" title' do
        result = described_class.parse_leaf(
          'U.C.B Aprobada:',
          'U.C.B Aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1'
        )

        expect(result).to eq(
          type: 'subject', needs: 'all',
          subject_needed_code: '1424',
          subject_needed_name: 'ARQUITECTURA DE COMPUTADORES 1'
        )
      end

      it 'parses "Actividad Examen aprobada/reprobada en la U.C.B:" title' do
        result = described_class.parse_leaf(
          'Actividad Examen aprobada/reprobada en la U.C.B:',
          'Actividad Examen aprobada/reprobada en la U.C.B: 1151 - FISICA 1'
        )

        expect(result).to eq(
          type: 'subject', needs: 'exam_activity',
          subject_needed_code: '1151', subject_needed_name: 'FISICA 1'
        )
      end

      it 'parses "Actividad Curso aprobada/reprobada en la U.C.B:" title' do
        content = 'Actividad Curso aprobada/reprobada en la U.C.B: 1030 - GEOMETRIA Y ALGEBRA LINEAL 1'
        result = described_class.parse_leaf(
          'Actividad Curso aprobada/reprobada en la U.C.B:', content
        )

        expect(result).to eq(
          type: 'subject', needs: 'course_activity',
          subject_needed_code: '1030',
          subject_needed_name: 'GEOMETRIA Y ALGEBRA LINEAL 1'
        )
      end
    end

    context 'with credits prerequisite title' do
      it 'parses credits in a Grupo' do
        result = described_class.parse_leaf(
          '15 créditos en el Grupo:',
          '15 créditos en el Grupo: 4756 - A.INTEG,TALLERES,PASANT.Y PROY'
        )

        expect(result).to eq(type: 'credits', credits: 15, group: 4756)
      end

      it 'parses credits in a Plan' do
        result = described_class.parse_leaf(
          '380 créditos en el Plan:',
          '380 créditos en el Plan: 1997 - INGENIERIA EN COMPUTACION'
        )

        expect(result).to eq(type: 'credits', credits: 380)
      end
    end

    # rubocop:disable Layout/LineLength
    context 'with logical leaf prerequisite title' do
      it 'parses a single aprobación as "or"' do
        content = "1 aprobación/es entre: \nCurso de la U.C.B: 1511 - SISTEMAS OPERATIVOS\nCurso de la U.C.B: 1512 - SISTEMAS OPERATIVOS 2\n"

        result = described_class.parse_leaf('1 aprobación/es entre:', content)

        expect(result).to eq(
          type: 'logical',
          logical_operator: 'or',
          operands: [
            { type: 'subject', subject_needed_code: '1511', subject_needed_name: 'SISTEMAS OPERATIVOS', needs: 'course' },
            { type: 'subject', subject_needed_code: '1512', subject_needed_name: 'SISTEMAS OPERATIVOS 2', needs: 'course' },
          ]
        )
      end

      it 'parses all aprobaciones needed as "and"' do
        content = "2 aprobación/es entre: \nCurso de la U.C.B: 1324 - PROGRAMACION 4\nCurso de la U.C.B: 1010 - LOGICA Y COMPUTACION\n"

        result = described_class.parse_leaf('2 aprobación/es entre:', content)

        expect(result).to eq(
          type: 'logical',
          logical_operator: 'and',
          operands: [
            { type: 'subject', subject_needed_code: '1324', subject_needed_name: 'PROGRAMACION 4', needs: 'course' },
            { type: 'subject', subject_needed_code: '1010', subject_needed_name: 'LOGICA Y COMPUTACION', needs: 'course' },
          ]
        )
      end

      it 'parses partial aprobaciones as "at_least"' do
        content = "2 aprobación/es entre: \nCurso de la U.C.B: 1511 - SISTEMAS OPERATIVOS\nCurso de la U.C.B: 1512 - SISTEMAS OPERATIVOS 2\nCurso de la U.C.B: 1513 - SISTEMAS OPERATIVOS 3\n"

        result = described_class.parse_leaf('2 aprobación/es entre:', content)

        expect(result).to eq(
          type: 'logical',
          logical_operator: 'at_least',
          amount_of_subjects_needed: 2,
          operands: [
            { type: 'subject', subject_needed_code: '1511', subject_needed_name: 'SISTEMAS OPERATIVOS', needs: 'course' },
            { type: 'subject', subject_needed_code: '1512', subject_needed_name: 'SISTEMAS OPERATIVOS 2', needs: 'course' },
            { type: 'subject', subject_needed_code: '1513', subject_needed_name: 'SISTEMAS OPERATIVOS 3', needs: 'course' },
          ]
        )
      end

      it 'parses actividad/es title' do
        content = "1 actividad/es entre: \nExamen de la U.C.B: 1151 - FISICA 1\nExamen de la U.C.B: 1152 - FISICA 2\n"

        result = described_class.parse_leaf('1 actividad/es entre:', content)

        expect(result).to eq(
          type: 'logical',
          logical_operator: 'or',
          operands: [
            { type: 'subject', subject_needed_code: '1151', subject_needed_name: 'FISICA 1', needs: 'exam' },
            { type: 'subject', subject_needed_code: '1152', subject_needed_name: 'FISICA 2', needs: 'exam' },
          ]
        )
      end

      it 'parses mixed approvable types (U.C.B aprobada, Examen, Curso)' do
        content = "1 aprobación/es entre: \nU.C.B aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1\nExamen de la U.C.B: 1453 - COMPL.ARQUITECTURA DE COMPUTADORAS\nCurso de la U.C.B: 1511 - SISTEMAS OPERATIVOS\n"

        result = described_class.parse_leaf('1 aprobación/es entre:', content)

        expect(result[:operands].map { |o| o[:needs] }).to eq(%w[all exam course])
      end
    end
    # rubocop:enable Layout/LineLength

    it 'raises for unknown title' do
      expect {
        described_class.parse_leaf('Unknown title:', 'some content')
      }.to raise_error(RuntimeError, /Unknown node title/)
    end
  end

  describe '.parse_subject_content' do
    it 'parses content without location prefix' do
      result = described_class.parse_subject_content(
        'Curso aprobado de la U.C.B: 1324 - PROGRAMACION 4'
      )

      expect(result).to eq([nil, '1324', 'PROGRAMACION 4'])
    end

    it 'parses content with location prefix' do
      result = described_class.parse_subject_content(
        'Examen aprobado de la U.C.B: CENURLN - SRN03 - ALGEBRA LINEAL I'
      )

      expect(result).to eq(['CENURLN - ', 'SRN03', 'ALGEBRA LINEAL I'])
    end

    it 'parses U.C.B aprobada content' do
      result = described_class.parse_subject_content(
        'U.C.B Aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1'
      )

      expect(result).to eq([nil, '1424', 'ARQUITECTURA DE COMPUTADORES 1'])
    end

    it 'parses Examen de la U.C.B content' do
      result = described_class.parse_subject_content(
        'Examen de la U.C.B: 1453 - COMPL.ARQUITECTURA DE COMPUTADORAS'
      )

      expect(result).to eq([nil, '1453', 'COMPL.ARQUITECTURA DE COMPUTADORAS'])
    end
  end

  describe '.parse_credits_prerequisite' do
    it 'parses Grupo credits' do
      result = described_class.parse_credits_prerequisite(
        '15 créditos en el Grupo: 4756 - A.INTEG,TALLERES,PASANT.Y PROY'
      )

      expect(result).to eq(type: 'credits', credits: 15, group: 4756)
    end

    it 'parses Plan credits without group' do
      result = described_class.parse_credits_prerequisite(
        '380 créditos en el Plan: 1997 - INGENIERIA EN COMPUTACION'
      )

      expect(result).to eq(type: 'credits', credits: 380)
    end
  end

  describe '.classify_approvable' do
    it 'classifies U.C.B aprobada as "all"' do
      result = described_class.classify_approvable(
        'U.C.B aprobada: 1424 - ARQUITECTURA DE COMPUTADORES 1'
      )

      expect(result).to eq('all')
    end

    it 'classifies Examen de la U.C.B as "exam"' do
      result = described_class.classify_approvable(
        'Examen de la U.C.B: 1453 - COMPL.ARQUITECTURA DE COMPUTADORAS'
      )

      expect(result).to eq('exam')
    end

    it 'classifies Curso de la U.C.B as "course"' do
      result = described_class.classify_approvable(
        'Curso de la U.C.B: 1511 - SISTEMAS OPERATIVOS'
      )

      expect(result).to eq('course')
    end

    it 'raises for unknown approvable' do
      expect {
        described_class.classify_approvable('Unknown: 1234 - SOMETHING')
      }.to raise_error(RuntimeError, /Unknown approvable/)
    end
  end
end
