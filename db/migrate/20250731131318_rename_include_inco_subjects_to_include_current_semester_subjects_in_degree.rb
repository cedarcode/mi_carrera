class RenameIncludeIncoSubjectsToIncludeCurrentSemesterSubjectsInDegree < ActiveRecord::Migration[8.0]
  def change
    rename_column :degrees, :include_inco_subjects, :include_current_semester_subjects
  end
end
