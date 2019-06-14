class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable'
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable'
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
end
