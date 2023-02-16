class RemoveNullFalseFromSubjectsGroupId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :subjects, :group_id, true
  end
end
