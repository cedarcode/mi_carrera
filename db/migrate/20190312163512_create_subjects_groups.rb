class CreateSubjectsGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :group_id, :integer

    remove_column :dependency_items, :credits_needed, :integer

    create_table :subjects_groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :credits_prerequisites do |t|
      t.integer :dependency_item_id, null: false
      t.integer :subjects_group_id
      t.integer :credits_needed, null: false

      t.timestamps
    end
  end
end
