class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  scope :ordered_by_semester_and_name, -> { order(:semester, :name) }

  scope :with_exam, -> { includes(:exam).where.not(exam: { id: nil }) }
  scope :without_exam, -> { includes(:exam).where(exam: { id: nil }) }

  def self.approved_credits(approved_courses, approved_exams)
    without_exam.where(id: approved_courses).or(
      with_exam.where(id: approved_exams)
    ).sum(:credits)
  end

  def approved?(approved_courses, approved_exams)
    exam ? approved_exams.include?(id) : approved_courses.include?(id)
  end

  delegate :available?, to: :course
end
