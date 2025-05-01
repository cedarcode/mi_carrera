# frozen_string_literal: true

class BooleanReviewComponent < ViewComponent::Base
  attr_reader :review_name, :value, :subject_id, :column_name, :user_review

  def initialize(review_name:, value:, subject_id: nil, column_name: :value, user_review: nil)
    @review_name = review_name
    @value = value
    @subject_id = subject_id
    @column_name = column_name.to_sym
    @user_review = user_review
  end
end 
