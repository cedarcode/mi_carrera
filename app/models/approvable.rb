class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite", dependent: :destroy

  validates :is_exam, inclusion: { in: [true, false] }

  def approved?(approved_courses, approved_exams)
    is_exam ? approved_exams.include?(subject_id) : approved_courses.include?(subject_id)
  end

  def available?(approved_courses, approved_exams)
    if prerequisite_tree
      prerequisite_tree.met?(approved_courses, approved_exams)
    else
      true
    end
  end
end
