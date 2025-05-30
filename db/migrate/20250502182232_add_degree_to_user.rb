class AddDegreeToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :degree, foreign_key: true
  end
end
