class ChangeWebauthnIdToUuidInUsers < ActiveRecord::Migration[8.0]
  def change
    # rubocop:disable Rails/BulkChangeTable
    remove_column :users, :webauthn_id, :string
    add_column :users, :webauthn_id, :uuid, null: false, default: -> { "gen_random_uuid()" }
    # rubocop:enable Rails/BulkChangeTable
  end
end
