class AddSecondSemesterEvaIdToSubject < ActiveRecord::Migration[8.0]
  def up
    add_column :subjects, :second_semester_eva_id, :string, if_not_exists: true
  end

  def down
    remove_column :subjects, :second_semester_eva_id, if_exists: true
  end
end
