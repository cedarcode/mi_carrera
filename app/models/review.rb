class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validate :at_least_one_review_field_present

  # List of attributes that make up a review
  REVIEW_FIELDS = [:rating, :recommended].freeze

  # Returns true if all review fields are nil
  def all_review_fields_blank?(except: [])
    # undefined method 'except' for an instance of Array
    REVIEW_FIELDS.reject { |field| except.include?(field) }.all? { |field| self.send(field).nil? }
  end

  private

  def at_least_one_review_field_present
    if rating.nil? && recommended.nil?
      errors.add(:base, "At least one review field must be present")
    end
  end
end
