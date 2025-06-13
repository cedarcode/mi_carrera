require 'rails_helper'

RSpec.describe Approvable, type: :model do
  describe 'associations' do
    it { should belong_to(:subject) }
    it { should have_one(:prerequisite_tree).class_name('Prerequisite').dependent(:destroy) }
  end

  describe '#approved?' do
    context 'when not is_exam and course approved' do
      it 'is true' do
        subject = create(:subject, :with_exam)
        course = subject.course

        expect(course.approved?([])).to be false
        expect(course.approved?([subject.course.id])).to be true
      end
    end

    context 'when is_exam and exam approved' do
      it 'is true' do
        subject = create(:subject, :with_exam)
        exam = subject.exam

        expect(exam.approved?([])).to be false
        expect(exam.approved?([subject.course.id])).to be false
        expect(exam.approved?([subject.course.id, subject.exam.id])).to be true
      end
    end
  end

  describe '#available?' do
    context 'when no prerequisite' do
      it 'is true' do
        subject = create(:subject)
        course = subject.course

        expect(course.available?([])).to be true
      end
    end

    context 'when prerequisite met' do
      it 'is true' do
        subject1 = create(:subject)
        subject2 = create(:subject)

        mock = double('PrerequisiteTree')
        expect(mock).to receive(:met?).with([subject1.course.id]).and_return(true)

        allow(subject2.course).to receive(:prerequisite_tree).and_return(mock)

        expect(subject2.course.available?([subject1.course.id])).to be true
      end
    end

    context 'when prerequisite not met' do
      it 'is false' do
        subject1 = create(:subject)
        subject2 = create(:subject)

        mock = double('PrerequisiteTree')
        expect(mock).to receive(:met?).with([subject1.course.id]).and_return(false)

        allow(subject2.course).to receive(:prerequisite_tree).and_return(mock)

        expect(subject2.course.available?([subject1.course.id])).to be false
      end
    end
  end
end
