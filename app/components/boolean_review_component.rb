# frozen_string_literal: true

class BooleanReviewComponent < ViewComponent::Base
  STYLES = {
    form: %w[
      transition-transform
      duration-[250ms]
      ease-[ease]
      hover:scale-[1.3]
    ],
    button: %w[material-icons cursor-pointer !text-xl]
  }

  def initialize(review_name:, rating_value: nil, subject_id:, user_review: nil, rating_attribute:)
    @review_name = review_name
    @rating_value = rating_value
    @subject_id = subject_id
    @rating_attribute = rating_attribute
    @user_review_value = user_review&.public_send(rating_attribute)
  end

  private

  attr_reader :review_name, :rating_value, :subject_id, :rating_attribute, :user_review_value

  def display_rating
    rating_value.nil? ? '?' : "#{rating_value}%"
  end

  def vote_button(value)
    button_to vote_icon(value), reviews_path,
              method: :post,
              params: vote_params(value),
              class: vote_button_classes(value),
              form: { class: STYLES[:form] }
  end

  def vote_icon(value)
    if selected?(value)
      value ? 'thumb_up' : 'thumb_down'
    else
      value ? 'thumb_up_off_alt' : 'thumb_down_off_alt'
    end
  end

  def vote_params(value)
    rating_value = selected?(value) ? nil : value
    { subject_id: subject_id, rating_attribute => rating_value }
  end

  def vote_button_classes(value) = STYLES[:button] + [vote_color_classes(value)]

  def vote_color_classes(value) = selected?(value) ? 'text-violet-400' : 'text-gray-400'

  def selected?(value) = !user_review_value.nil? && user_review_value == value
end
