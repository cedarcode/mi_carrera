class AddMinApprovedSubjectsToPrerequisite < ActiveRecord::Migration[7.0]
  def change
    add_column :prerequisites, :amount_of_subjects_needed, :integer
  end
end
