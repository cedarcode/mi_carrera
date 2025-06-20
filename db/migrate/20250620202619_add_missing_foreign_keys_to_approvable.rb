class AddMissingForeignKeysToApprovable < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :approvables, :subjects
    add_index :approvables, :subject_id
  end
end
