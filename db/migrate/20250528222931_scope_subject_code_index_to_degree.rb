class ScopeSubjectCodeIndexToDegree < ActiveRecord::Migration[8.0]
  def change
    remove_index :subjects, :code
    add_index :subjects, [:degree_id, :code], unique: true
  end
end
