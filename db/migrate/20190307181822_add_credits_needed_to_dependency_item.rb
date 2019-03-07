class AddCreditsNeededToDependencyItem < ActiveRecord::Migration[5.2]
  def change
    add_column :dependency_items, :credits_needed, :integer, default: 0
  end
end
