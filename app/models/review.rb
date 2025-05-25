class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validate :at_least_one_review_field_present

  # Dynamically determine review fields based on model attributes
  # Exclude standard Rails/ActiveRecord attributes
  def self.review_fields
    @review_fields ||= attribute_names.map(&:to_sym) -
                       [:id, :user_id, :subject_id, :created_at, :updated_at]
  end

  # Check if all review fields would be blank after excluding certain fields
  def would_be_blank_without?(fields_to_exclude = [])
    remaining_fields = self.class.review_fields - Array(fields_to_exclude)
    remaining_fields.all? { |field| send(field).nil? }
  end

  # Smart update that destroys the record if it would become empty
  def smart_update!(attributes)
    assign_attributes(attributes)

    if would_be_blank_without?
      destroy!
    else
      save!
    end
  end

  private

  def at_least_one_review_field_present
    if self.class.review_fields.all? { |field| send(field).nil? }
      errors.add(:base, "At least one review field must be present")
    end
  end
end
