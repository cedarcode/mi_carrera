require 'rails_helper'

RSpec.describe YmlLoader do
  let(:degree_id) { 'test_degree' }
  let(:degree_dir) { Rails.root.join("db/data/#{degree_id}/") }

  before do
    allow(Rails.configuration).to receive(:degrees).and_return([
      {
        bedelias_name: 'TEST DEGREE',
        id: degree_id,
        current_plan: '2025',
        include_inco_subjects: true
      }
    ])

    Dir.mkdir(degree_dir)

    File.write(degree_dir.join("scraped_subject_groups.yml"), {
      '2003' => {
        'code' => '2003',
        'name' => 'TEST GROUP',
        'min_credits' => 70
      }
    }.to_yaml)

    File.write(degree_dir.join("scraped_subjects.yml"), {
      '101' => {
        'code' => '101',
        'name' => 'TEST SUBJECT I',
        'credits' => 10,
        'has_exam' => true,
        'subject_group' => '2003'
      },
      '102' => {
        'code' => '102',
        'name' => 'TEST SUBJECT II',
        'credits' => 12,
        'has_exam' => false,
        'subject_group' => '2003'
      },
    }.to_yaml)

    File.write(degree_dir.join("subject_overrides.yml"), {
      '101' => {
        'eva_id' => '25',
        'openfing_id' => 'testsubj',
        'short_name' => 'TS1',
        'category_name' => 'third_semester',
      }
    }.to_yaml)

    File.write(degree_dir.join("scraped_prerequisites.yml"), [
      {
        'type' => 'logical',
        'logical_operator' => 'and',
        'operands' => [
          {
            'type' => 'credits',
            'credits' => 60,
          },
        ],
        'subject_code' => '101',
        'is_exam' => false
      }
    ].to_yaml)

    File.write(degree_dir.join("scraped_optional_subjects.yml"), ["102"].to_yaml)
  end

  after do
    FileUtils.rm_rf(degree_dir)
  end

  describe '.load' do
    it 'loads' do
      # It loads the degree
      expect { described_class.load }.to change(Degree, :count).by(1)
      degree = Degree.find_by(id: degree_id)
      expect(degree).to be_present
      expect(degree.current_plan).to eq('2025')
      expect(degree.include_inco_subjects).to eq(true)
    end
  end

  describe 'load' do
  end
end
