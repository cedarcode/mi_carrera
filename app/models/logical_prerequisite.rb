class LogicalPrerequisite < Prerequisite
  LOGICAL_OPERATORS = ["and", "or", "not"]

  has_many(
    :operands_prerequisites,
    class_name: 'Prerequisite',
    inverse_of: 'parent_prerequisite',
    foreign_key: "parent_prerequisite_id",
    dependent: :destroy
  )

  validates :logical_operator, inclusion: { in: LOGICAL_OPERATORS, message: "%{value} is not a valid logical operator" }

  def met?(approved_courses, approved_exams)
    case logical_operator
    when "and"
      operands_prerequisites.all? { |prereq| prereq.met?(approved_courses, approved_exams) }
    when "or"
      operands_prerequisites.any? { |prereq| prereq.met?(approved_courses, approved_exams) }
    when "not"
      operands_prerequisites.none? { |prereq| prereq.met?(approved_courses, approved_exams) }
    end
  end
end
