class ScopeSubjectGroupCodeIndexToDegree < ActiveRecord::Migration[8.0]
  def change
    remove_index :subject_groups, :code
    add_index :subject_groups, [:degree_id, :code], unique: true
  end
end
