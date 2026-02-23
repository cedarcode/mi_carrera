class AddHiddenToDegreePlans < ActiveRecord::Migration[8.1]
  def change
    add_column :degree_plans, :hidden, :boolean, default: false, null: false
  end
end
