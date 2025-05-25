# frozen_string_literal: true

class FiveStarReviewComponentPreview < ViewComponent::Preview
  def default
    render(FiveStarReviewComponent.new(review_name: "(review name)", rating: 4))
  end

  def high_rating
    render(FiveStarReviewComponent.new(
             review_name: "High Rating Review",
             rating: 4.7
           ))
  end

  def low_rating
    render(FiveStarReviewComponent.new(
             review_name: "Low Rating Review",
             rating: 2.3
           ))
  end

  def no_rating
    render(FiveStarReviewComponent.new(
             review_name: "No Rating Yet",
             rating: nil
           ))
  end

  def with_user_review
    # This would typically come from your database
    user_review = OpenStruct.new(
      id: 1,
      rating: 4
    )

    render(FiveStarReviewComponent.new(
             review_name: "Review with User Rating",
             rating: 3.8,
             subject_id: 123,
             column_name: :rating,
             user_review: user_review
           ))
  end
end
