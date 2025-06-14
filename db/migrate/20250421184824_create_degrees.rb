class CreateDegrees < ActiveRecord::Migration[8.0]
  def change
    create_table :degrees do |t|
      t.string :title, null: false
      t.string :name, null: false
      t.string :current_plan, null: false
      t.boolean :include_inco_subjects, null: false

      t.timestamps
    end

    add_index :degrees, :name, unique: true
  end
end
