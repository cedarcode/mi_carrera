require 'rails_helper'

RSpec.describe Subject, type: :model do
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

  describe '#ordered_by_category_and_name' do
    let(:s1) { create :subject, category: :first_semester, name: 'A' }
    let(:s2) { create :subject, category: :second_semester, name: 'B' }
    let(:s3) { create :subject, category: :first_semester, name: 'C' }

    it 'returns subjects ordered by category and name' do
      expect(Subject.ordered_by_category_and_name).to eq([s1, s3, s2])
    end
  end
end
