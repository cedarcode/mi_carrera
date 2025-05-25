# frozen_string_literal: true

class FiveStarReviewComponentPreview < ViewComponent::Preview
  def default
    render(FiveStarReviewComponent.new(review_name: "(review name)", rating: 4))
  end
end 
