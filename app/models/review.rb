class Review < ApplicationRecord
  acts_as_tenant :degree

  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
