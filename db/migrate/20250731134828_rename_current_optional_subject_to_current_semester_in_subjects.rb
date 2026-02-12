class RenameCurrentOptionalSubjectToCurrentSemesterInSubjects < ActiveRecord::Migration[8.0]
  def change
    rename_column :subjects, :current_optional_subject, :current_semester
    change_column_null :subjects, :current_semester, false
  end
end
