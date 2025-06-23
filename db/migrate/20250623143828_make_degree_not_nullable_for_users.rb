class MakeDegreeNotNullableForUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :degree_id, false
  end
end
