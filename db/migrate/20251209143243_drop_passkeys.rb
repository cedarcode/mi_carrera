class DropPasskeys < ActiveRecord::Migration[8.1]
  def change
    drop_table :passkeys do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.string :public_key, null: false
      t.string :name, null: false
      t.bigint :sign_count, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
