class AddDegreePlanReferences < ActiveRecord::Migration[8.1]
  def change
    add_reference :subjects, :degree_plan, foreign_key: true
    add_reference :subject_groups, :degree_plan, foreign_key: true
    add_reference :users, :degree_plan, foreign_key: true
  end
end
