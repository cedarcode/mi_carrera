class AddCurrentOptionalSubjectToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :current_optional_subject, :boolean, default: false
  end
end
