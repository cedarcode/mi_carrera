class DependencyItem < ApplicationRecord
  belongs_to :subject
  has_and_belongs_to_many(
    :prerequisites,
    class_name: "DependencyItem",
    join_table: "dependencies",
    association_foreign_key: "prerequisite_id"
  )
  has_and_belongs_to_many(
    :dependants,
    class_name: "DependencyItem",
    join_table: "dependencies",
    foreign_key: "prerequisite_id"
  )
  has_many :credits_prerequisites

  validates :is_exam, inclusion: { in: [true, false] }
end
