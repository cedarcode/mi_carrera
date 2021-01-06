class AddApprovalsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :approvals, :text
  end
end
