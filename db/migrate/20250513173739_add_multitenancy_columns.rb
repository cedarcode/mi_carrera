class AddMultitenancyColumns < ActiveRecord::Migration[8.0]
  def change
    add_reference :subject_groups, :degree, foreign_key: true
    add_reference :subjects, :degree, foreign_key: true
  end
end
