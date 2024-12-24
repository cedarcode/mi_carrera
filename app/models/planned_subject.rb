class PlannedSubject < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :subject_id, uniqueness: { scope: :user_id }
end
