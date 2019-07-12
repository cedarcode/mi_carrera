class AddCodeToSubjectGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :subject_groups, :code, :string
    add_index :subject_groups, :code, unique: true
  end
end
