class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy
  belongs_to :group, class_name: 'SubjectGroup'

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  def stored_exam
    approvables = Bedel.approvables_by_subject_id[id]
    approvables&.each do |approvable|
      if approvable[:is_exam]
        return approvable
      end
    end
    nil
  end

  def stored_course
    approvables = Bedel.approvables_by_subject_id[id]
    approvables&.each do |approvable|
      if !approvable[:is_exam]
        return approvable
      end
    end
    nil
  end
end
