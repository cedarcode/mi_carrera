class AddExternalToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :external, :boolean, default: false
  end
end
