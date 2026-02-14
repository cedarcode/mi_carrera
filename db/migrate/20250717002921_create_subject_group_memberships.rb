class CreateSubjectGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :subject_group_memberships do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :subject_group, null: false, foreign_key: true
      t.integer :credits, null: false
      t.timestamps
    end

    add_index :subject_group_memberships, [:subject_id, :subject_group_id],
              unique: true,
              name: 'index_subject_group_memberships_on_subject_and_group'
  end
end
