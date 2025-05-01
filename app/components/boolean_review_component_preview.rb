# frozen_string_literal: true

class BooleanReviewComponentPreview < ViewComponent::Preview
  def positive
    render(BooleanReviewComponent.new(
      review_name: "(review name)",
      value: true
    ))
  end

  def negative
    render(BooleanReviewComponent.new(
      review_name: "(review name)",
      value: false
    ))
  end
end 
