class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validate :at_least_one_review_field_present

  private

  def at_least_one_review_field_present
    if rating.nil? && recommended.nil?
      errors.add(:base, "At least one review field must be present")
    end
  end
end
