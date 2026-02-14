class CreateDegreePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :degree_plans do |t|
      t.belongs_to :degree, null: false, foreign_key: true, index: false, type: :string
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.index %i[degree_id name], unique: true
      t.timestamps
    end
  end
end
