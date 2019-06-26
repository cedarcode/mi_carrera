class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite"

  validates :is_exam, inclusion: { in: [true, false] }
end
