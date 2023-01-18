class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite", dependent: :destroy

  validates :is_exam, inclusion: { in: [true, false] }

  def approved?(approved_courses, approved_exams)
    is_exam ? approved_exams.include?(subject_id) : approved_courses.include?(subject_id)
  end
end
