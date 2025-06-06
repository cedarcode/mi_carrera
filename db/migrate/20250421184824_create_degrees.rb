class CreateDegrees < ActiveRecord::Migration[8.0]
  def change
    create_table :degrees do |t|
      t.string :title
      t.string :name, null: false
      t.string :current_plan
      t.boolean :include_inco_subjects

      t.timestamps
    end

    add_index :degrees, :name, unique: true
  end
end
