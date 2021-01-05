class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite", dependent: :destroy

  validates :is_exam, inclusion: { in: [true, false] }
end
