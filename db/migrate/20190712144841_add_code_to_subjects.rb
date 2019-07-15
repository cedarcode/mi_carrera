class AddCodeToSubjects < ActiveRecord::Migration[6.0]
  def change
    add_column :subjects, :code, :string
    add_index :subjects, :code, unique: true
  end
end
