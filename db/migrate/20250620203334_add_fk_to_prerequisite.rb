class AddFkToPrerequisite < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :prerequisites, :prerequisites, column: :parent_prerequisite_id
    add_foreign_key :prerequisites, :approvables
    add_foreign_key :prerequisites, :approvables, column: :approvable_needed_id
    add_foreign_key :prerequisites, :subject_groups

    add_index :prerequisites, :parent_prerequisite_id
    add_index :prerequisites, :approvable_id
    add_index :prerequisites, :approvable_needed_id
    add_index :prerequisites, :subject_group_id
  end
end
