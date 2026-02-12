# frozen_string_literal: true

class BooleanReviewComponentPreview < ViewComponent::Preview
  # @!group States

  def no_ratings
    render(BooleanReviewComponent.new(
             review_name: "Recomendado",
             subject_id: 123,
             rating_attribute: :recommended_rating
           ))
  end

  def with_user_review_positive
    user_review = Review.new(
      recommended_rating: true,
      subject_id: 123
    )

    render(BooleanReviewComponent.new(
             review_name: "Recomendado",
             rating_value: 75,
             subject_id: 123,
             user_review: user_review,
             rating_attribute: :recommended_rating
           ))
  end

  def with_user_review_negative
    user_review = Review.new(
      recommended_rating: false,
      subject_id: 123
    )

    render(BooleanReviewComponent.new(
             review_name: "Recomendado",
             rating_value: 25,
             subject_id: 123,
             user_review: user_review,
             rating_attribute: :recommended_rating
           ))
  end

  # @!endgroup
end
