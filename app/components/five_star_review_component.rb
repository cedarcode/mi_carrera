class FiveStarReviewComponent < ViewComponent::Base
  attr_reader :review_name, :rating_value, :subject_id, :column_name

  def initialize(review_name:, rating_value: nil, subject_id:, user_review: nil, column_name:)
    @review_name = review_name
    @rating_value = rating_value
    @subject_id = subject_id
    @user_review = user_review
    @column_name = column_name
    @user_review_rating = user_review&.send(column_name)
  end

  def display_rating
    rating_value.present? ? number_with_precision(rating_value, precision: 1) : '-.-'
  end

  def star_options
    5.downto(1).map do |value|
      {
        value:,
        url: selected?(value) ? review_path(@user_review) : reviews_path,
        form_method: selected?(value) ? :delete : :post,
        button_icon: filled?(value) ? 'star' : 'star_outline',
        button_color: filled?(value) ? 'text-violet-400' : 'text-gray-400'
      }
    end
  end

  private

  def filled?(value)
    @user_review_rating.present? && @user_review_rating >= value
  end

  def selected?(value)
    @user_review_rating.present? && @user_review_rating == value
  end
end
