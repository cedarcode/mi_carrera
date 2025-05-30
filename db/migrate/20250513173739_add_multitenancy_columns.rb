class AddMultitenancyColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :subject_groups, :degree_id, :integer
    add_index :subject_groups, :degree_id

    add_column :subjects, :degree_id, :integer
    add_index :subjects, :degree_id
  end
end
