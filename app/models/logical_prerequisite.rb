class LogicalPrerequisite < Prerequisite
  validates :logical_operator, presence: true
  has_many(
    :operands_prerequisites,
    class_name: 'Prerequisite',
    inverse_of: 'prerequisite',
    foreign_key: "prerequisite_id"
  )
end
