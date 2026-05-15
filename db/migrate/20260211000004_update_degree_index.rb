class UpdateDegreeIndex < ActiveRecord::Migration[8.1]
  def change
    add_index :subjects, [:degree_plan_id, :code], unique: true
    add_index :subject_groups, [:degree_plan_id, :code], unique: true

    remove_index :subjects, [:degree_id, :code], unique: true
    remove_index :subject_groups, [:degree_id, :code], unique: true
  end
end
