# frozen_string_literal: true

class BooleanReviewComponent < ViewComponent::Base
  attr_reader :review_name, :rating_value, :subject_id, :column_name

  def initialize(review_name:, rating_value: nil, subject_id:, user_review: nil, column_name:)
    @review_name = review_name
    @rating_value = rating_value
    @subject_id = subject_id
    @user_review_value = user_review&.send(column_name)
    @column_name = column_name
  end

  def display_value
    rating_value.nil? ? '?' : "#{rating_value.round(0)}%"
  end

  def vote_options
    [false, true].map do |value|
      {
        value:,
        selected: selected?(value),
        button_icon: button_icon(value),
        button_color: selected?(value) ? 'text-violet-400' : 'text-gray-400'
      }
    end
  end

  def hidden_rating_field_value(value)
    selected?(value) ? nil : value
  end

  private

  def selected?(value)
    !@user_review_value.nil? && @user_review_value == value
  end

  def button_icon(value)
    if selected?(value)
      value ? 'thumb_up' : 'thumb_down'
    else
      value ? 'thumb_up_off_alt' : 'thumb_down_off_alt'
    end
  end
end
