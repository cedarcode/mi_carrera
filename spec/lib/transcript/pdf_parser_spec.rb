require 'rails_helper'

RSpec.describe Transcript::PdfParser, type: :lib do
  # rubocop:disable Layout/LineLength
  let(:pdf_mock) {
    [
      double('page', text: "  Test Subject 1                                                                10        0     20/02/2024 Aceptable"),
      double('page', text: "  Test Subject 2                                                                 9        0     20/02/2024 Bueno"),
      double('page', text: "  Test Subject 3                                                                 8        0     20/02/2024 Muy Bueno"),
      double('page', text: "  Test Subject 4                                                                 7        0     20/02/2024 Excelente"),
      double('page', text: "  Test Subject 5                                                                 6        0     20/02/2024 S/C"),
      double('page', text: "  Failed Subject 1                                                               8        1     ********** ***")
    ]
  }
  # rubocop:enable Layout/LineLength

  describe '.process' do
    let(:file) { double('file', path: 'path') }
    let(:reader) { double('reader') }
    let(:academic_entries_list) {
      [
        build(:academic_entry, name: 'Test Subject 1', credits: '10', date_of_completion: '20/02/2024', grade: 'Aceptable'),
        build(:academic_entry, name: 'Test Subject 2', credits: '9', date_of_completion: '20/02/2024', grade: 'Bueno'),
        build(:academic_entry, name: 'Test Subject 3', credits: '8', date_of_completion: '20/02/2024', grade: 'Muy Bueno'),
        build(:academic_entry, name: 'Test Subject 4', credits: '7', date_of_completion: '20/02/2024', grade: 'Excelente'),
        build(:academic_entry, name: 'Test Subject 5', credits: '6', date_of_completion: '20/02/2024', grade: 'S/C'),
        build(:academic_entry, :failed, name: 'Failed Subject 1', credits: '8')
      ]
    }

    before do
      allow(PDF::Reader).to receive(:new).with('path').and_return(reader)
      allow(reader).to receive(:pages).and_return(pdf_mock)
    end

    it 'returns a list of academic entries' do
      expect(described_class.new(file).to_a).to all(be_an(Transcript::AcademicEntry))
    end

    it 'parses the text from the pdf file' do
      result = described_class.new(file).to_a
      expect(result.map(&:name)).to eq(academic_entries_list.map(&:name))
      expect(result.map(&:credits)).to eq(academic_entries_list.map(&:credits))
      expect(result.map(&:number_of_failures)).to eq(academic_entries_list.map(&:number_of_failures))
      expect(result.map(&:date_of_completion)).to eq(academic_entries_list.map(&:date_of_completion))
      expect(result.map(&:grade)).to eq(academic_entries_list.map(&:grade))
    end
  end
end
