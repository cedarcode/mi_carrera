class AddSemesterToSubjectPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :subject_plans, :semester, :integer, null: false # rubocop:disable Rails/NotNullColumn
  end
end
