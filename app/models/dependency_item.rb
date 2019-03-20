class DependencyItem < ApplicationRecord
  belongs_to :subject
  has_one :prerequisites, class_name: "Prerequisite"

  validates :is_exam, inclusion: { in: [true, false] }
end
