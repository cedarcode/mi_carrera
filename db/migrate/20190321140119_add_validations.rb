class AddValidations < ActiveRecord::Migration[5.2]
  def change
    change_column_null :subjects, :name, false
    change_column_null :subjects, :credits, false
    change_column_null :subjects, :group_id, false

    change_column_null :subject_groups, :name, false
  end
end
