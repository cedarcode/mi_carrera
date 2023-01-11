class CreatePrerequisiteTree < ActiveRecord::Migration[5.2]
  def change
    create_table :prerequisites do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string  :type, null: false
      t.integer :parent_prerequisite_id
      t.integer :dependency_item_id

      t.string  :logical_operator

      t.integer :credits_needed
      t.integer :subject_group_id

      t.integer :dependency_item_needed_id
    end

    drop_table :dependencies # rubocop:disable Rails/ReversibleMigration

    drop_table :credits_prerequisites # rubocop:disable Rails/ReversibleMigration
  end
end
