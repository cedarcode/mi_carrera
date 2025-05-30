class CreateDegrees < ActiveRecord::Migration[8.0]
  def change
    create_table :degrees do |t|
      t.string :name
      t.string :key, null: false, default: ""
      t.string :current_plan
      t.boolean :include_inco_subjects

      t.timestamps
    end

    add_index :degrees, :key, unique: true
  end
end
