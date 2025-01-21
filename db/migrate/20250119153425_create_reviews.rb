class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :rating
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
