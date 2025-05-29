# frozen_string_literal: true

class BooleanReviewComponentPreview < ViewComponent::Preview
  # @!group States

  def no_ratings
    render(BooleanReviewComponent.new(
             review_name: "Recomendado",
             subject_id: 123,
             column_name: :recommended
           ))
  end

  def with_user_review
    user_review = Review.new(
      recommended: true,
      subject_id: 123
    )

    render(BooleanReviewComponent.new(
             review_name: "Recomendado",
             rating_value: 75.0,
             subject_id: 123,
             user_review: user_review,
             column_name: :recommended,
           ))
  end

  # @!endgroup
end
