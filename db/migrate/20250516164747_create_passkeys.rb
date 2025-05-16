class CreatePasskeys < ActiveRecord::Migration[8.0]
  def change
    create_table :passkeys do |t|
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.string :name, null: false
      t.bigint :sign_count, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :passkeys, :external_id, unique: true
  end
end
