class RenamePlannedSubjectToSubjectPlan < ActiveRecord::Migration[8.0]
  def change
    rename_table :planned_subjects, :subject_plans
  end
end
