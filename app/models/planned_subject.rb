class PlannedSubject < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates_uniqueness_of :subject_id, scope: :user_id
end
