class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  scope :ordered_by_semester_and_name, -> { order(:semester, :name) }

  scope :with_exam, -> { includes(:exam, :course).where.not(exam: { id: nil }) }
  scope :without_exam, -> { includes(:exam, :course).where(exam: { id: nil }) }

  def self.approved_credits(approved_approvable_ids)
    without_exam.where(course: { id: approved_approvable_ids }).or(
      with_exam.where(exam: { id: approved_approvable_ids })
    ).sum(:credits)
  end

  def approved?(approved_approvable_ids)
    approved_approvable_ids.include?(exam ? exam.id : course.id)
  end

  delegate :available?, to: :course
end
