class UpdateReviewsRatingColumns < ActiveRecord::Migration[8.0]
  def change
    change_table :reviews, bulk: true do |t|
      t.remove :rating, type: :integer
      t.integer :interesting_rating
      t.integer :credits_to_difficulty_rating
    end
  end
end
