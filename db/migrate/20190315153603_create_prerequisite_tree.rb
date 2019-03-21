class CreatePrerequisiteTree < ActiveRecord::Migration[5.2]
  def change
    create_table :prerequisites do |t|
      t.string  :type, null: false
      t.integer :prerequisite_id
      t.integer :dependency_item_id

      t.string  :logical_operator

      t.integer :credits_needed
      t.integer :subject_group_id

      t.integer :dependency_item_needed_id
    end

    drop_table :dependencies

    drop_table :credits_prerequisites
  end
end
