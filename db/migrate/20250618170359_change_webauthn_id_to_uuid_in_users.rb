class ChangeWebauthnIdToUuidInUsers < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :webauthn_id, :uuid, default: -> { "gen_random_uuid()" }, using: "webauthn_id::uuid"
  end

  def down
    change_column :users, :webauthn_id, :string
  end
end
