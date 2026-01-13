class MakeDegreeNotNullableForSubjectsAndGroups < ActiveRecord::Migration[8.0]
  def change
    change_column_null :subjects, :degree_id, false
    change_column_null :subject_groups, :degree_id, false
  end
end
