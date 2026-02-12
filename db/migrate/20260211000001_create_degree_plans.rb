class CreateDegreePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :degree_plans do |t|
      t.string :degree_id, null: false
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end

    add_foreign_key :degree_plans, :degrees
    add_index :degree_plans, [:degree_id, :name], unique: true
  end
end
