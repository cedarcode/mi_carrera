class AddTitleToDegrees < ActiveRecord::Migration[8.1]
  def change
    add_column :degrees, :name, :string
  end
end
