class PersistCreditsForUser < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.integer :total_credits, default: 0, null: false
      t.jsonb :group_credits, default: {}, null: false
    end
  end
end
