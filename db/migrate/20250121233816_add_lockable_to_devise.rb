class AddLockableToDevise < ActiveRecord::Migration[8.0]
  def change
    # Only if lock strategy is :failed_attempts
    add_column :users, :failed_attempts, :integer, default: 0, null: false

    add_column :users, :locked_at, :datetime
  end
end
