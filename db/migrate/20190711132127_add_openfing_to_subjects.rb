class AddOpenfingToSubjects < ActiveRecord::Migration[6.0]
  def change
    add_column :subjects, :openfing_id, :string
  end
end
