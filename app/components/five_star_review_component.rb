# frozen_string_literal: true

class FiveStarReviewComponent < ViewComponent::Base
  attr_reader :review_name, :rating, :subject_id, :column_name, :user_review

  def initialize(review_name:, rating:, subject_id: nil, column_name: :rating, user_review: nil)
    @review_name = review_name
    @rating = rating
    @subject_id = subject_id
    @column_name = column_name.to_sym
    @user_review = user_review
  end
end 
