class DependencyItem < ApplicationRecord
  belongs_to :subject
  has_and_belongs_to_many(
    :prerequisites,
    class_name: "DependencyItem",
    join_table: "dependencies",
    association_foreign_key: "prerequisite_id"
  )
end
