class RemoveHiddenByDefaultFromSubjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :subjects, :hidden_by_default, :boolean, default: false
  end
end
