class Approvable < ApplicationRecord
  after_create :reload_subjects

  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite", dependent: :destroy

  validates :is_exam, inclusion: { in: [true, false] }

  def reload_subjects
    Bedel.reload_subjects
  end
end
