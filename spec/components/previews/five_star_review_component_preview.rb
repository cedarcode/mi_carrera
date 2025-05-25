# frozen_string_literal: true

class FiveStarReviewComponentPreview < ViewComponent::Preview
  # @!group States

  def no_ratings
    render(FiveStarReviewComponent.new(
             review_name: "Interesante",
             subject_id: 123,
             column_name: :interesting
           ))
  end

  def with_user_review
    user_review = Review.new(
      interesting: 4,
      subject_id: 123
    )

    render(FiveStarReviewComponent.new(
             review_name: "Interesante",
             rating_value: 3.8,
             subject_id: 123,
             user_review: user_review,
             column_name: :interesting,
           ))
  end
  # @!endgroup
end
