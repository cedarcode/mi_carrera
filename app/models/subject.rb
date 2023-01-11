class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  scope :ordered_by_semester_and_name, -> { order(:semester, :name) }
end
