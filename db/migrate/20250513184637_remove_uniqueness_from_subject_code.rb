class RemoveUniquenessFromSubjectCode < ActiveRecord::Migration[8.0]
  def change
    remove_index :subjects, :code
    add_index :subjects, :code
  end
end
