class AddTitleToDegrees < ActiveRecord::Migration[8.1]
  def change
    add_column :degrees, :title, :string
  end
end
