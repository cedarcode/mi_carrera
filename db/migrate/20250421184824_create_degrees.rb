class CreateDegrees < ActiveRecord::Migration[8.0]
  def change
    create_table :degrees, id: :string do |t|
      t.string :current_plan, null: false
      t.boolean :include_current_semester_subjects, null: false

      t.timestamps
    end
  end
end
