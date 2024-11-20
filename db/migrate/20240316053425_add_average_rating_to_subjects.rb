class AddAverageRatingToSubjects < ActiveRecord::Migration[7.1]
  def change
    add_column :subjects, :average_rating, :float
  end
end
