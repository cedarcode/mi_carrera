class AddEvaToSubjects < ActiveRecord::Migration[6.0]
  def change
    add_column :subjects, :eva_id, :string
  end
end
