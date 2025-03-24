class SubjectPlan < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :subject_id, uniqueness: { scope: :user_id }
  validates :semester, numericality: { only_integer: true, greater_than: 0 }
end
