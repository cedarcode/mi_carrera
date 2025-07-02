class FiveStarReviewComponent < ViewComponent::Base
  STYLES = {
    form: %w[
      transition-transform
      duration-[250ms]
      ease-[ease]
      hover:scale-[1.3]
      [&:hover~&]:scale-[1.3]
    ],
    button: %w[material-icons cursor-pointer !text-xl]
  }

  def initialize(review_name:, rating_value: nil, subject_id:, user_review: nil, rating_attribute:)
    @review_name = review_name
    @rating_value = rating_value
    @subject_id = subject_id
    @rating_attribute = rating_attribute
    @user_review_rating = user_review&.public_send(rating_attribute)
  end

  private

  attr_reader :review_name, :rating_value, :subject_id, :rating_attribute, :user_review_rating

  def display_rating
    number_with_precision(rating_value, precision: 1) || '-.-'
  end

  def star_button(value)
    button_to star_icon(value), reviews_path,
              method: :post,
              params: star_params(value),
              class: star_button_classes(value),
              form: { class: STYLES[:form] }
  end

  def star_icon(value) = filled?(value) ? 'star' : 'star_outline'

  def star_params(value)
    rating_value = selected?(value) ? nil : value
    { subject_id: subject_id, rating_attribute => rating_value }
  end

  def star_button_classes(value) = STYLES[:button] + [star_color_classes(value)]

  def star_color_classes(value) = filled?(value) ? 'text-violet-400' : 'text-gray-400'

  def filled?(value) = user_review_rating&.>= value

  def selected?(value) = user_review_rating == value
end
