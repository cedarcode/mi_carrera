class RemoveDegreeColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :subjects, :degree_id, :string
    remove_column :subject_groups, :degree_id, :string
    remove_column :users, :degree_id, :string
  end
end
