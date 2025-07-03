class AddSemestersToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :planned_semesters, :integer, default: 10, null: false
  end
end
