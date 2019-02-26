class CreateDependencyItems < ActiveRecord::Migration[5.2]
  def change
    create_table :dependency_items do |t|
      t.integer :subject_id, null: false
      t.boolean :is_exam, null: false

      t.timestamps
    end

    create_table :dependencies do |t|
      t.integer :dependency_item_id, null: false
      t.integer :prerequisite_id, null: false

      t.timestamps
    end
  end
end
