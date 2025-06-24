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
        'second_semester_eva_id' => '400',
        'openfing_id' => 'testsubj',
        'short_name' => 'TS1',
        'category' => 'third_semester',
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
      },
      {
        'type' => 'logical',
        'logical_operator' => 'and',
        'operands' => [
          {
            'type' => 'subject',
            'needs' => 'course',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
        ],
        'subject_code' => '101',
        'is_exam' => true
      },
      {
        'type' => 'logical',
        'logical_operator' => 'and',
        'operands' => [
          {
            'type' => 'subject',
            'needs' => 'exam',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'subject',
            'needs' => 'all',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'subject',
            'needs' => 'course_enrollment',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'subject',
            'needs' => 'exam_enrollment',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'subject',
            'needs' => 'course_activity',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'subject',
            'needs' => 'exam_activity',
            'subject_needed_code' => '101',
            'subject_needed_name' => 'TEST SUBJECT I',
          },
          {
            'type' => 'credits',
            'credits' => 35,
            'group' => "2003",
          },
        ],
        'subject_code' => '102',
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
      # Degrees
      expect { described_class.load }.to change(Degree, :count).by(1)
      degree = Degree.find_by(id: degree_id)
      expect(degree).to be_present
      expect(degree.current_plan).to eq('2025')
      expect(degree.include_inco_subjects).to be true

      # Subject Groups
      expect(SubjectGroup.count).to eq(1)
      subject_group = degree.subject_groups.find_by(code: '2003')
      expect(subject_group).to be_present
      expect(subject_group.name).to eq('Test Group')
      expect(subject_group.credits_needed).to eq(70)

      # Subjects
      expect(Subject.count).to eq(2)
      subject1 = Subject.find_by(code: '101')
      expect(subject1).to be_present
      expect(subject1.name).to eq('Test Subject I')
      expect(subject1.credits).to eq(10)
      expect(subject1.course).to be_present
      expect(subject1.exam).to be_present
      expect(subject1.group).to eq(subject_group)
      expect(subject1.eva_id).to eq('25')
      expect(subject1.second_semester_eva_id).to eq('400')
      expect(subject1.openfing_id).to eq('testsubj')
      expect(subject1.short_name).to eq('TS1')
      expect(subject1.category).to eq('third_semester')
      expect(subject1.current_optional_subject).to be false

      subject2 = Subject.find_by(code: '102')
      expect(subject2).to be_present
      expect(subject2.name).to eq('Test Subject II')
      expect(subject2.credits).to eq(12)
      expect(subject2.course).to be_present
      expect(subject2.exam).to be_nil
      expect(subject2.group).to eq(subject_group)
      expect(subject2.eva_id).to be_nil
      expect(subject2.second_semester_eva_id).to be_nil
      expect(subject2.openfing_id).to be_nil
      expect(subject2.short_name).to be_nil
      expect(subject2.category).to eq('optional')
      expect(subject2.current_optional_subject).to be true

      # Prerequisites
      expect(subject1.course.prerequisite_tree).to be_a(LogicalPrerequisite)
      expect(subject1.course.prerequisite_tree.logical_operator).to eq("and")
      expect(subject1.course.prerequisite_tree.amount_of_subjects_needed).to be_nil
      expect(subject1.course.prerequisite_tree.operands_prerequisites.length).to eq(1)
      operand_prereq = subject1.course.prerequisite_tree.operands_prerequisites.first
      expect(operand_prereq).to be_a(CreditsPrerequisite)
      expect(operand_prereq.credits_needed).to eq(60)
      expect(operand_prereq.subject_group).to be_nil

      expect(subject1.exam.prerequisite_tree).to be_a(LogicalPrerequisite)
      expect(subject1.exam.prerequisite_tree.logical_operator).to eq("and")
      expect(subject1.exam.prerequisite_tree.amount_of_subjects_needed).to be_nil
      expect(subject1.exam.prerequisite_tree.operands_prerequisites.length).to eq(1)
      operand_prereq2 = subject1.exam.prerequisite_tree.operands_prerequisites.first
      expect(operand_prereq2).to be_a(SubjectPrerequisite)
      expect(operand_prereq2.approvable_needed).to eq(subject1.course)

      expect(subject2.course.prerequisite_tree).to be_a(LogicalPrerequisite)
      expect(subject2.course.prerequisite_tree.logical_operator).to eq("and")
      expect(subject2.course.prerequisite_tree.amount_of_subjects_needed).to be_nil
      expect(subject2.course.prerequisite_tree.operands_prerequisites.length).to eq(7)
      operands = subject2.course.prerequisite_tree.operands_prerequisites
      expect(operands[0]).to be_a(SubjectPrerequisite)
      expect(operands[0].approvable_needed).to eq(subject1.exam)
      expect(operands[1]).to be_a(SubjectPrerequisite)
      expect(operands[1].approvable_needed).to eq(subject1.exam)
      expect(operands[2]).to be_a(EnrollmentPrerequisite)
      expect(operands[2].approvable_needed).to eq(subject1.course)
      expect(operands[3]).to be_a(EnrollmentPrerequisite)
      expect(operands[3].approvable_needed).to eq(subject1.exam)
      expect(operands[4]).to be_a(ActivityPrerequisite)
      expect(operands[4].approvable_needed).to eq(subject1.course)
      expect(operands[5]).to be_a(ActivityPrerequisite)
      expect(operands[5].approvable_needed).to eq(subject1.exam)
      expect(operands[6]).to be_a(CreditsPrerequisite)
      expect(operands[6].credits_needed).to eq(35)
      expect(operands[6].subject_group).to eq(subject_group)
    end

    it 'raises error if unknown prerequisite type' do
      File.write(degree_dir.join('scraped_prerequisites.yml'), [
        {
          'type' => 'foo',
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

      expect { described_class.load }.to raise_error('Unknown prerequisite type: foo')
    end

    it 'raises error if unknown approvable needed' do
      File.write(degree_dir.join('scraped_prerequisites.yml'), [
        {
          'type' => 'logical',
          'logical_operator' => 'and',
          'operands' => [
            {
              'type' => 'subject',
              'needs' => 'bar',
              'subject_needed_code' => '101',
              'subject_needed_name' => 'TEST SUBJECT I',
            },
          ],
          'subject_code' => '101',
          'is_exam' => false
        }
      ].to_yaml)

      expect { described_class.load }.to raise_error('Unknown approvable needed: bar')
    end
  end

  describe 'load' do
  end
end
