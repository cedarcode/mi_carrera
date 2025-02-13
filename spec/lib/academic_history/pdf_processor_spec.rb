require 'rails_helper'

RSpec.describe AcademicHistory::PdfProcessor, type: :lib do
  let(:pdf_mock) {[
    double('page', text: "  Test Subject 1                                                                10        0     20/02/2024 Aceptable"),
    double('page', text: "  Test Subject 2                                                                 9        0     20/02/2024 Bueno"),
    double('page', text: "  Test Subject 3                                                                 8        0     20/02/2024 Muy Bueno"),
    double('page', text: "  Test Subject 4                                                                 7        0     20/02/2024 Excelente"),
    double('page', text: "  Test Subject 5                                                                 6        0     20/02/2024 S/C"),
    double('page', text: "  Failed Subject 1                                                               8        1     ********** ***")
  ]}

  let(:academic_entries) { described_class::AcademicEntry }

  describe '.process' do
    let(:file) { double('file', path: 'path') }
    let(:reader) { double('reader') }
    let(:academic_entries_list) {[
      academic_entries.new('Test Subject 1', '10', '0', '20/02/2024', 'Aceptable'),
      academic_entries.new('Test Subject 2', '9', '0', '20/02/2024', 'Bueno'),
      academic_entries.new('Test Subject 3', '8', '0', '20/02/2024', 'Muy Bueno'),
      academic_entries.new('Test Subject 4', '7', '0', '20/02/2024', 'Excelente'),
      academic_entries.new('Test Subject 5', '6', '0', '20/02/2024', 'S/C'),
      academic_entries.new('Failed Subject 1', '8', '1', '**********', '***')
    ]}

    before do
      allow(PDF::Reader).to receive(:new).with('path').and_return(reader)
      allow(reader).to receive(:pages).and_return(pdf_mock)
    end

    it 'returns a list of academic entries' do
      expect(described_class.process(file)).to all(be_an(academic_entries))
    end

    it 'parses the text from the pdf file' do
      expect(described_class.process(file)).to eq(academic_entries_list)
    end
  end

  describe 'academic entry' do
    let(:entry) { academic_entries.new('Test Subject', '10', '0', '20/02/2024', 'Aceptable') }
    let(:failed_entry) { academic_entries.new('Failed Subject', '10', '1', '**********', '***') }

    it 'has a name' do
      expect(entry.name).to eq('Test Subject')
    end

    it 'has a number of credits' do
      expect(entry.credits).to eq('10')
    end

    it 'has a number of failures' do
      expect(entry.number_of_failures).to eq('0')
    end

    it 'has a date of completion' do
      expect(entry.date_of_completion).to eq('20/02/2024')
    end

    it 'has a grade' do
      expect(entry.grade).to eq('Aceptable')
    end

    it 'is approved if the grade is not ***' do
      expect(entry).to be_approved
    end

    it 'is not approved if the grade is ***' do
      expect(failed_entry).not_to be_approved
    end
  end
end
