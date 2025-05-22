class AddMultitenancyColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :approvables, :degree_id, :integer
    add_index :approvables, :degree_id

    add_column :prerequisites, :degree_id, :integer
    add_index :prerequisites, :degree_id

    add_column :reviews, :degree_id, :integer
    add_index :reviews, :degree_id

    add_column :subject_groups, :degree_id, :integer
    add_index :subject_groups, :degree_id

    add_column :subject_plans, :degree_id, :integer
    add_index :subject_plans, :degree_id

    add_column :subjects, :degree_id, :integer
    add_index :subjects, :degree_id
  end
end
