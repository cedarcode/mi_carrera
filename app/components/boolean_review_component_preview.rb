# frozen_string_literal: true

class BooleanReviewComponentPreview < ViewComponent::Preview
  def positive
    render(BooleanReviewComponent.new(
             review_name: "Positive Review",
             value: 85.5
           ))
  end

  def negative
    render(BooleanReviewComponent.new(
             review_name: "Negative Review",
             value: 23.2
           ))
  end

  def nil_value
    render(BooleanReviewComponent.new(
             review_name: "Unknown Review",
             value: nil
           ))
  end

  def with_user_review
    # This would typically come from your database
    user_review = OpenStruct.new(
      id: 1,
      value: true
    )

    render(BooleanReviewComponent.new(
             review_name: "Review with User Input",
             value: 75.0,
             subject_id: 123,
             column_name: :value,
             user_review: user_review
           ))
  end
end
