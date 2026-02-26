class AddRecommendedRatingToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :recommended_rating, :boolean
  end
end
