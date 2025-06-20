class AddFkAndIndexToSubject < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :subjects, :subject_groups, column: :group_id

    add_index :subjects, :group_id
  end
end
