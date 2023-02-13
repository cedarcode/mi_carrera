class LogicalPrerequisite < Prerequisite
  LOGICAL_OPERATORS = ["and", "or", "not", "at_least"]

  has_many(
    :operands_prerequisites,
    class_name: 'Prerequisite',
    inverse_of: 'parent_prerequisite',
    foreign_key: "parent_prerequisite_id",
    dependent: :destroy
  )

  validates :logical_operator, inclusion: { in: LOGICAL_OPERATORS, message: "%{value} is not a valid logical operator" }
  validate :amount_of_subjects_less_than_prerequisites_count, if: %i[amount_of_subjects_needed]

  def met?(approved_approvable_ids)
    case logical_operator
    when "and"
      operands_prerequisites.all? { |prereq| prereq.met?(approved_approvable_ids) }
    when "or"
      operands_prerequisites.any? { |prereq| prereq.met?(approved_approvable_ids) }
    when "not"
      operands_prerequisites.none? { |prereq| prereq.met?(approved_approvable_ids) }
    when "at_least"
      operands_prerequisites.count { |prereq| prereq.met?(approved_approvable_ids) } >= amount_of_subjects_needed
    end
  end

  private

  def amount_of_subjects_less_than_prerequisites_count
    if amount_of_subjects_needed > operands_prerequisites.size
      errors.add :amount_of_subjects_needed, "must be less than or equal to operands prerequisites count"
    end
  end
end
