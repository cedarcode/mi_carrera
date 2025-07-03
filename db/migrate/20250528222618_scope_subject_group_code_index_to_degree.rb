class ScopeSubjectGroupCodeIndexToDegree < ActiveRecord::Migration[8.0]
  def change
    add_index :subject_groups, [:degree_id, :code], unique: true
    remove_index :subject_groups, :code
  end
end
