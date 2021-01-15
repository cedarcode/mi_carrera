class AddRecoveryPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :recovery_password_digest, :string
  end
end
