class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  def exam
    approvables = Bedel::APPROVABLES_BY_SUBJECT_ID[id]
    approvables.each do |approvable|
      return approvable if approvable[:is_exam]
    end
  end

  def course
    approvables = Bedel::APPROVABLES_BY_SUBJECT_ID[id]
    approvables.each do |approvable|
      return approvable if !approvable[:is_exam]
    end
  end
end
