class LogicalPrerequisite < Prerequisite
  LOGICAL_OPERATORS = ["and", "or"]

  has_many(
    :operands_prerequisites,
    class_name: 'Prerequisite',
    inverse_of: 'parent_prerequisite',
    foreign_key: "parent_prerequisite_id"
  )

  validates :logical_operator, inclusion: { in: LOGICAL_OPERATORS, message: "%{value} is not a valid logical operator" }
end
