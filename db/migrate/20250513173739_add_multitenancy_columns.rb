class AddMultitenancyColumns < ActiveRecord::Migration[8.0]
  def change
    add_reference :subject_groups, :degree, foreign_key: true, type: :string
    add_reference :subjects, :degree, foreign_key: true, type: :string
  end
end
