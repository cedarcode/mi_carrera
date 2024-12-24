class CreatePlannedSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :planned_subjects do |t|
      t.belongs_to :user, null: false
      t.belongs_to :subject, null: false

      t.timestamps
    end
  end
end
