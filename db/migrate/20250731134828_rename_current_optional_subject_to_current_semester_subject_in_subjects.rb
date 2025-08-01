class RenameCurrentOptionalSubjectToCurrentSemesterSubjectInSubjects < ActiveRecord::Migration[8.0]
  def change
    rename_column :subjects, :current_optional_subject, :current_semester_subject
  end
end
