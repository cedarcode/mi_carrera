class RemoveIncludeIncoSubjectsFromDegrees < ActiveRecord::Migration[8.0]
  def change
    remove_column :degrees, :include_inco_subjects, :boolean, null: false
  end
end
