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

  def display_rating
    rating.present? ? sprintf('%.1f', rating) : '-.-'
  end

  def star_options
    5.downto(1).map do |value|
      {
        value: value,
        filled: filled?(value),
        selected: selected?(value),
        icon: filled?(value) ? 'star' : 'star_outline',
        color_class: filled?(value) ? 'text-violet-400' : 'text-gray-400'
      }
    end
  end

  def hidden_field_value(value)
    selected?(value) ? nil : value
  end

  private

  def filled?(value)
    user_review&.send(column_name).present? && user_review.send(column_name) >= value
  end

  def selected?(value)
    user_review&.send(column_name).present? && user_review.send(column_name) == value
  end
end
