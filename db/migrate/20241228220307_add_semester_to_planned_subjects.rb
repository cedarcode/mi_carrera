class AddSemesterToPlannedSubjects < ActiveRecord::Migration[8.0]
  def change
    add_column :planned_subjects, :semester, :integer
  end
end
