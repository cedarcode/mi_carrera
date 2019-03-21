class LogicalPrerequisite < Prerequisite
  validates :logical_operator, presence: true
  has_many(
    :operands_prerequisites,
    class_name: 'Prerequisite',
    inverse_of: 'parent_prerequisite',
    foreign_key: "parent_prerequisite_id"
  )
end
