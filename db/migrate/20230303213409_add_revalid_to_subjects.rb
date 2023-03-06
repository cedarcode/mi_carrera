class AddRevalidToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :revalid, :boolean, default: false
  end
end
