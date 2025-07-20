require 'rails_helper'

RSpec.describe YmlLoader do
  let(:degree_id) { 'test_degree' }
  let(:another_degree_id) { 'another_test_degree' }

  before do
    stub_const("YmlLoader::BASE_DIR", base_dir)

    allow(Rails.configuration).to receive(:degrees).and_return([
      {
        bedelias_name: 'TEST DEGREE',
        id: degree_id,
        current_plan: '2025',
        include_inco_subjects: true
      },
      {
        bedelias_name: 'ANOTHER TEST DEGREE',
        id: another_degree_id,
        current_plan: '1815',
        include_inco_subjects: true
      }
    ])
  end

  describe '.load' do
    context 'when yamls are correct' do
      let(:base_dir) { Rails.root.join("spec/support/mock_yamls/success") }

      it 'loads new data' do
        # Degrees
        expect { described_class.load }.to change(Degree, :count).by(2)
        degree = Degree.find(degree_id)
        expect(degree.current_plan).to eq('2025')
        expect(degree.include_inco_subjects).to be true

        # Subject Groups
        expect(degree.subject_groups.count).to eq(1)
        subject_group = degree.subject_groups.find_by!(code: '2003')
        expect(subject_group.name).to eq('Matemática')
        expect(subject_group.credits_needed).to eq(70)

        # Subjects
        expect(degree.subjects.count).to eq(3)
        subject1 = degree.subjects.find_by!(code: '101')
        expect(subject1.name).to eq('Cálculo I')
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

        subject2 = degree.subjects.find_by!(code: '102')
        expect(subject2.name).to eq('Cálculo II')
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

        subject3 = degree.subjects.find_by!(code: '25')
        expect(subject3.name).to eq('Subject With No Group')
        expect(subject3.group).to be_nil

        # Prerequisites
        expect(subject1.course.prerequisite_tree).to be_a(LogicalPrerequisite)
        expect(subject1.course.prerequisite_tree.logical_operator).to eq("or")
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
        expect(subject2.course.prerequisite_tree.operands_prerequisites.length).to eq(10)
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
        expect(operands[7]).to be_a(LogicalPrerequisite)
        expect(operands[7].logical_operator).to eq("at_least")
        expect(operands[7].amount_of_subjects_needed).to eq(1)
        expect(operands[7].operands_prerequisites.length).to eq(1)
        expect(operands[7].operands_prerequisites.first).to be_a(SubjectPrerequisite)
        expect(operands[7].operands_prerequisites.first.approvable_needed).to eq(subject1.exam)
        expect(operands[8]).to be_a(LogicalPrerequisite)
        expect(operands[8].logical_operator).to eq("not")
        expect(operands[8].operands_prerequisites.length).to eq(1)
        expect(operands[8].operands_prerequisites.first).to be_a(EnrollmentPrerequisite)
        expect(operands[8].operands_prerequisites.first.approvable_needed).to eq(subject3.course)
        expect(operands[9]).to be_a(SubjectPrerequisite)
        expect(operands[9].approvable_needed).to eq(subject3.course)

        # Data isolation between degrees
        another_degree = Degree.find(another_degree_id)
        expect(another_degree.subject_groups.pluck(:code)).to contain_exactly("73")
        expect(another_degree.subjects.pluck(:code)).to contain_exactly("25")

        subject4 = another_degree.subjects.find_by!(code: '25')
        expect(subject4.name).to eq('Another Test Subject')
        expect(subject4.group.code).to eq('73')
        expect(subject4.course).to be_present
        expect(subject4.exam).to be_present
        expect(subject4.credits).to eq(4)
      end

      context 'when data already exists' do
        let!(:existing_degree) { create(:degree, id: degree_id, current_plan: '1830', include_inco_subjects: false) }
        let!(:existing_group) do
          create(
            :subject_group,
            code: '2003',
            name: 'Existing Group',
            credits_needed: 50,
            degree_id:
          )
        end
        let!(:existing_subject) do
          create(
            :subject,
            code: '101',
            name: 'Existing Subject',
            credits: 100,
            degree_id:,
            current_optional_subject: true
          )
        end
        let!(:subject_with_exam) do
          create(
            :subject,
            :with_exam,
            code: '25',
            name: 'Existing Subject with Exam',
            degree_id:,
          )
        end

        it 'updates existing data' do
          described_class.load

          existing_degree.reload
          expect(existing_degree.current_plan).to eq('2025')
          expect(existing_degree.include_inco_subjects).to eq(true)

          existing_group.reload
          expect(existing_group.name).to eq('Matemática')
          expect(existing_group.credits_needed).to eq(70)

          existing_subject.reload
          expect(existing_subject.name).to eq('Cálculo I')
          expect(existing_subject.credits).to eq(10)
          expect(existing_subject.exam).to be_present
          expect(existing_subject.group).to eq(existing_group)
          expect(existing_subject.current_optional_subject).to be false

          expect(subject_with_exam.reload.exam).to be_present
        end
      end
    end

    context 'when there is an unknown prerequiste type' do
      let(:base_dir) { Rails.root.join("spec/support/mock_yamls/unknown_prerequisite_type") }

      it 'raises error if unknown prerequisite type' do
        expect { described_class.load }.to raise_error('Unknown prerequisite type: foo')
      end
    end

    context 'when there is an unknown approvable needed' do
      let(:base_dir) { Rails.root.join("spec/support/mock_yamls/unknown_approvable_type") }

      it 'raises error if unknown approvable needed' do
        expect { described_class.load }.to raise_error('Unknown approvable needed: bar')
      end
    end
  end
end
