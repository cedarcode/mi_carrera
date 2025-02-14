class AddSecondSemesterEvaIdToSubject < ActiveRecord::Migration[8.0]
  def change
    add_column :subjects, :second_semester_eva_id, :string
  end
end
