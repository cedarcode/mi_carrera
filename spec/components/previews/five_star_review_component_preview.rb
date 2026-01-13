class FiveStarReviewComponentPreview < ViewComponent::Preview
  # @!group States

  def no_ratings
    render(FiveStarReviewComponent.new(
             review_name: "Puntuación",
             subject_id: 123,
             rating_attribute: :interesting_rating
           ))
  end

  def with_user_review
    user_review = FactoryBot.build_stubbed(:review, interesting_rating: 3)

    render(FiveStarReviewComponent.new(
             review_name: "Puntuación",
             rating_value: 3.8,
             subject_id: user_review.subject_id,
             user_review: user_review,
             rating_attribute: :interesting_rating,
           ))
  end
  # @!endgroup
end
