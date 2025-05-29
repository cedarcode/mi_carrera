class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :interesting, inclusion: { in: 1..5 }, allow_nil: true
  validates :credits_to_difficulty_ratio, inclusion: { in: 1..5 }, allow_nil: true
end
