class CreatePlannedSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :planned_subjects do |t|
      t.belongs_to :user, null: false, index: false, foreign_key: true
      t.belongs_to :subject, null: false, index: false, foreign_key: true

      t.timestamps
    end

    add_index :planned_subjects, [:user_id, :subject_id], unique: true
  end
end
