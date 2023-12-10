class AddCreditsNeededToSubjectGroup < ActiveRecord::Migration[7.1]
  def change
    add_column :subject_groups, :credits_needed, :integer, default: 0, null: false
  end
end
