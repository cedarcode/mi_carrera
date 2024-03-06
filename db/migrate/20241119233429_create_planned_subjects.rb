class CreatePlannedSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :planned_subjects do |t|
      t.belongs_to :user
      t.belongs_to :subject

      t.timestamps
    end
  end
end
