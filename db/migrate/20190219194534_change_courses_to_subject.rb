class ChangeCoursesToSubject < ActiveRecord::Migration[5.2]
  def change
    rename_table :courses, :subjects
  end
end
