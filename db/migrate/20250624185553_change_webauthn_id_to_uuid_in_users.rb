class ChangeWebauthnIdToUuidInUsers < ActiveRecord::Migration[8.0]
  def up
    change_table :users, bulk: true do |t|
      t.remove :webauthn_id
      t.column :webauthn_id, :uuid, null: false, default: -> { "gen_random_uuid()" }
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.remove :webauthn_id
      t.column :webauthn_id, :string
    end
  end
end
