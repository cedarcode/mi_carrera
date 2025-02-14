class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :subject, null: false, foreign_key: true, index: false
      t.integer :rating
      t.integer :recommend
      t.integer :interest


      t.timestamps
    end

    add_index :reviews, [:subject_id, :user_id], unique: true
  end
end
