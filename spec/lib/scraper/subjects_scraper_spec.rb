require 'rails_helper'
require 'scraper/subjects_scraper'

RSpec.describe Scraper::SubjectsScraper, type: :lib do
  describe 'SUBJECT_CODE_NAME_CREDITS_REGEX' do
    subject(:regex) { described_class::SUBJECT_CODE_NAME_CREDITS_REGEX }

    it 'parsea materia sin prefijo de instituto' do
      match = regex.match('SRN14 - MATEMÁTICA DISCRETA I - créditos: 10')
      expect(match.captures).to eq(['SRN14', 'MATEMÁTICA DISCRETA I', '10'])
    end

    it 'parsea materia con código numérico' do
      match = regex.match('1886 - TOPOLOGIA Y ANALISIS REAL - créditos: 10')
      expect(match.captures).to eq(['1886', 'TOPOLOGIA Y ANALISIS REAL', '10'])
    end

    it 'parsea materia con guión en el código' do
      match = regex.match('FF1-7 - CREDITOS ASIGNADOS POR REVALIDA - créditos: 7')
      expect(match.captures).to eq(['FF1-7', 'CREDITOS ASIGNADOS POR REVALIDA', '7'])
    end

    it 'parsea materia con punto en el código' do
      match = regex.match('FL2.6 - CREDITOS ASIGANDOS POR REVALIDA - créditos: 6')
      expect(match.captures).to eq(['FL2.6', 'CREDITOS ASIGANDOS POR REVALIDA', '6'])
    end

    it 'parsea materia con sufijo " programa"' do
      match = regex.match('SRN14 - MATEMÁTICA DISCRETA I - créditos: 10 programa')
      expect(match.captures).to eq(['SRN14', 'MATEMÁTICA DISCRETA I', '10'])
    end

    it 'parsea materia con prefijo de instituto CURE' do
      match = regex.match('CURE - DMA03 - GEOMETRÍA Y ÁLGEBRA LINEAL 1 - créditos: 12')
      expect(match.captures).to eq(['DMA03', 'GEOMETRÍA Y ÁLGEBRA LINEAL 1', '12'])
    end

    it 'parsea materia con prefijo de instituto CUT y código de materia con letras' do
      match = regex.match('CUT - AL - GEOMETRÍA Y ÁLGEBRA LINEAL - créditos: 9')
      expect(match.captures).to eq(['AL', 'GEOMETRÍA Y ÁLGEBRA LINEAL', '9'])
    end

    it 'parsea materia con prefijo de instituto CENURLN' do
      match = regex.match('CENURLN - CIM22 - TOPOLOGÍA - créditos: 12')
      expect(match.captures).to eq(['CIM22', 'TOPOLOGÍA', '12'])
    end

    it 'parsea materia con prefijo de instituto y nombre con guión interno' do
      match = regex.match('CENURLN - SRN45 - MATEMATICA INICIAL-OPTATIVA - créditos: 4')
      expect(match.captures).to eq(['SRN45', 'MATEMATICA INICIAL-OPTATIVA', '4'])
    end

    it 'no confunde código de materia que parece nombre de instituto cuando no hay prefijo' do
      match = regex.match('AL - GEOMETRÍA Y ÁLGEBRA LINEAL - créditos: 9')
      expect(match.captures).to eq(['AL', 'GEOMETRÍA Y ÁLGEBRA LINEAL', '9'])
    end

    it 'parsea nombre con " - " interno y sin prefijo de instituto' do
      match = regex.match('IIQ56 - METODOS CUANTITATIVOS III - PAYSANDU - créditos: 8')
      expect(match.captures).to eq(['IIQ56', 'METODOS CUANTITATIVOS III - PAYSANDU', '8'])
    end
  end
end
