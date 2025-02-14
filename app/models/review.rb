class Review < ApplicationRecord
  
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :recommend, inclusion: { in: 1..5 }, allow_nil: true
  validates :interest, inclusion: { in: 1..5 }, allow_nil: true

end
