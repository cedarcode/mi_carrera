class ScopeSubjectCodeIndexToDegree < ActiveRecord::Migration[8.0]
  def change
    add_index :subjects, [:degree_id, :code], unique: true
    remove_index :subjects, :code
  end
end
