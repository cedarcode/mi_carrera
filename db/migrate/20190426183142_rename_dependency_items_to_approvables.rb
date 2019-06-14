class RenameDependencyItemsToApprovables < ActiveRecord::Migration[6.0]
  def change
    rename_table :dependency_items, :approvables
    rename_column :prerequisites, :dependency_item_id, :approvable_id
    rename_column :prerequisites, :dependency_item_needed_id, :approvable_needed_id
  end
end
