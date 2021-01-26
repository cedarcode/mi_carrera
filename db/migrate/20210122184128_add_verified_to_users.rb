class AddVerifiedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :verified, :boolean, default: false
  end
end
