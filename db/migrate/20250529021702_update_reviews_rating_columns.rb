class UpdateReviewsRatingColumns < ActiveRecord::Migration[8.0]
  def change
    change_table :reviews, bulk: true do |t|
      t.remove :rating, type: :integer
      t.boolean :recommended
      t.integer :interesting
      t.integer :credits_to_difficulty_ratio
    end
  end
end
