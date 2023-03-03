class AddActiveToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :active, :boolean, default: true
  end
end
