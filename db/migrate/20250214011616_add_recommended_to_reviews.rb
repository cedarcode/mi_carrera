class AddRecommendedToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :recommended, :boolean
  end
end
