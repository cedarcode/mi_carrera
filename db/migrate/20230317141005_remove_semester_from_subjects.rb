class RemoveSemesterFromSubjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :subjects, :semester, :integer
  end
end
