require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'associations' do
    it { should belong_to(:degree) }
    it { should belong_to(:group).class_name('SubjectGroup').optional }
    it { should have_many(:subject_group_memberships).dependent(:destroy) }
    it {
      should have_one(:course)
        .class_name('Approvable')
        .conditions(is_exam: false)
        .dependent(:destroy)
        .inverse_of(:subject)
    }
    it {
      should have_one(:exam)
        .class_name('Approvable')
        .conditions(is_exam: true)
        .dependent(:destroy)
        .inverse_of(:subject)
    }
  end

  describe 'validations' do
    subject { build :subject }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:credits) }
    it { should validate_uniqueness_of(:code).scoped_to(:degree_plan_id) }
  end

  describe '#approved_credits' do
    let!(:s1) { create :subject, credits: 10 }
    let!(:s2) { create :subject, credits: 11 }
    let!(:s3) { create :subject, :with_exam, credits: 12 }

    it 'returns approved credits' do
      expect(Subject.approved_credits([])).to eq(0)
      expect(Subject.approved_credits([s1.course.id])).to eq(10)
      expect(Subject.approved_credits([s1.course.id, s2.course.id])).to eq(21)
      expect(Subject.approved_credits([s1.course.id, s2.course.id, s3.course.id])).to eq(21)
      expect(Subject.approved_credits([s1.course.id, s2.course.id, s3.course.id, s3.exam.id])).to eq(33)
    end
  end

  describe '#approved?' do
    context 'when exam not required and course approved' do
      let(:subject) { create :subject }

      it 'returns true' do
        expect(subject.approved?([])).to be false
        expect(subject.approved?([subject.course.id])).to be true
      end
    end

    context 'when exam required and exam approved' do
      let(:subject) { create :subject, :with_exam }

      it 'returns true' do
        expect(subject.approved?([])).to be false
        expect(subject.approved?([subject.course.id])).to be false
        expect(subject.approved?([subject.course.id, subject.exam.id])).to be true
      end
    end
  end

  describe '#average_interesting_rating' do
    let(:subject_record) { create :subject }

    context 'when there are no reviews' do
      it 'returns nil' do
        expect(subject_record.average_interesting_rating).to be_nil
      end
    end

    context 'when there are reviews without interesting rating' do
      let!(:review) { create :review, subject: subject_record }

      it 'returns nil' do
        expect(subject_record.average_interesting_rating).to be_nil
      end
    end

    context 'when there are reviews with interesting rating' do
      let!(:first_review) { create :review, subject: subject_record, interesting_rating: 2 }
      let!(:second_review) { create :review, subject: subject_record, interesting_rating: 4 }
      let!(:third_review) { create :review, subject: subject_record, interesting_rating: 5 }

      it 'returns the average interesting rating' do
        expect(subject_record.average_interesting_rating).to eq(3.7)
      end
    end
  end

  describe '#average_credits_to_difficulty_rating' do
    let(:subject_record) { create :subject }

    context 'when there are no reviews' do
      it 'returns nil' do
        expect(subject_record.average_credits_to_difficulty_rating).to be_nil
      end
    end

    context 'when there are reviews without credits to difficulty rating' do
      let!(:review) { create :review, subject: subject_record }

      it 'returns nil' do
        expect(subject_record.average_credits_to_difficulty_rating).to be_nil
      end
    end

    context 'when there are reviews with credits to difficulty rating' do
      let!(:first_review) { create :review, subject: subject_record, credits_to_difficulty_rating: 2 }
      let!(:second_review) { create :review, subject: subject_record, credits_to_difficulty_rating: 4 }
      let!(:third_review) { create :review, subject: subject_record, credits_to_difficulty_rating: 5 }

      it 'returns the average credits to difficulty rating' do
        expect(subject_record.average_credits_to_difficulty_rating).to eq(3.7)
      end
    end
  end

  describe '#available?' do
    let(:subject) { create :subject }
    let(:course) { subject.course }

    context 'when subject\'s course is not available' do
      before { allow(course).to receive(:available?).and_return(false) }

      it 'returns false' do
        expect(subject.available?([])).to be false
      end
    end

    context 'when subject\'s course is available' do
      before { allow(course).to receive(:available?).and_return(true) }

      it 'returns true when subject\'s course is available' do
        expect(subject.available?([])).to be true
      end
    end
  end

  describe '.with_exam' do
    let!(:s1) { create :subject }
    let!(:s2) { create :subject, :with_exam }

    it 'returns subjects that require exam' do
      expect(Subject.with_exam).to eq([s2])
    end
  end

  describe '.without_exam' do
    let!(:s1) { create :subject }
    let!(:s2) { create :subject, :with_exam }

    it 'returns subjects that do not require exam' do
      expect(Subject.without_exam).to eq([s1])
    end
  end

  describe '.search' do
    let!(:gal1) { create(:subject, name: "Geometría Y Álgebra Lineal 1", short_name: "GAL 1", code: "1030") }
    let!(:gal2) { create(:subject, name: "Geometría Y Álgebra Lineal 2", short_name: "GAL 2", code: "1031") }
    let!(:cdiv) {
      create(:subject, name: "Cálculo Dif. E Integral En Una Variable", short_name: "Calculo DIV", code: "1061")
    }

    it "finds by name" do
      expect(Subject.search("Geometría")).to contain_exactly(gal1, gal2)
    end

    it "finds by short name" do
      expect(Subject.search("GAL")).to contain_exactly(gal1, gal2)
    end

    it "finds by code" do
      expect(Subject.search("1061")).to contain_exactly(cdiv)
    end
  end

  describe '#ordered_by_category_and_name' do
    let(:s1) { create :subject, category: :first_semester, name: 'A' }
    let(:s2) { create :subject, category: :second_semester, name: 'B' }
    let(:s3) { create :subject, category: :first_semester, name: 'C' }

    it 'returns subjects ordered by category and name' do
      expect(Subject.ordered_by_category_and_name).to eq([s1, s3, s2])
    end
  end

  describe '#current_semester' do
    let(:s1) { create :subject, current_semester: true }
    let(:s2) { create :subject, current_semester: false }

    it 'returns subjects that are current semester optionals' do
      expect(Subject.current_semester).to eq([s1])
    end
  end

  describe ".approved_for" do
    context "when the subject doesn't have an exam" do
      it "returns it if the course is is in the param" do
        subject = create(:subject, name: "Subject 1")

        expect(Subject.approved_for([subject.course.id])).to include(subject)
        expect(Subject.approved_for([])).to be_empty
      end
    end

    context "when the subject has an exam" do
      it "returns it if the exam are in the param" do
        subject = create(:subject, :with_exam, name: "Subject 2")

        expect(Subject.approved_for([subject.exam.id])).to include(subject)
        expect(Subject.approved_for([subject.course.id])).to be_empty
        expect(Subject.approved_for([])).to be_empty
      end
    end
  end

  describe '.active' do
    let!(:inactive_subject) { create(:subject, category: 'inactive') }
    let!(:active_subject) { create(:subject, category: 'optional') }

    it 'returns only active subjects' do
      expect(Subject.active).to include(active_subject)
      expect(Subject.active).not_to include(inactive_subject)
    end
  end

  describe ".active_or_approved" do
    context "when the subject doesn't have an exam" do
      it "returns it if the course is is in the param or if the subject is active" do
        subject1 = create(:subject, category: :inactive)
        subject2 = create(:subject)

        expect(Subject.active_or_approved([subject1.course.id])).to include(subject1, subject2)
      end
    end

    context "when the subject has an exam" do
      it "returns it if the exam is in the param or if the subject is active" do
        subject1 = create(:subject, :with_exam, category: :inactive)
        subject2 = create(:subject, :with_exam)

        expect(Subject.active_or_approved([subject1.exam.id])).to include(subject1, subject2)
      end
    end
  end
end
