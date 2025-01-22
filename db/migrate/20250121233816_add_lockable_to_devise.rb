class AddLockableToDevise < ActiveRecord::Migration[8.0]
  def change
    change_table :users, bulk: true do |t|
      # Only if lock strategy is :failed_attempts
      t.integer :failed_attempts, default: 0, null: false
      t.datetime :locked_at
    end
  end
end
