class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, presence: true, inclusion: { in: 1..5 }

  after_commit :update_subject_rating, if: :saved_change_to_rating?
  after_destroy :update_subject_rating

  private

  def update_subject_rating
    subject.update_rating
  end
end
