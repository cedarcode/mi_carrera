class Prerequisite < ApplicationRecord
  belongs_to :parent_prerequisite, class_name: 'Prerequisite', optional: true
  belongs_to :approvable, optional: true

  def met?(_approved_courses, _approved_exams)
    raise NotImplementedError
  end
end
