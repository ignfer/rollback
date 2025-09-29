class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets, id: :uuid do |t|
      t.uuid :owner_id,                       default: null
      t.string  :name,           null: false
      t.string  :short_name
      t.string  :currency,       null: false
      t.decimal :balance,        null: false, default: 0, precision: 15, scale: 2
      t.boolean :is_credit_card, null: false, default: false

      t.timestamps
    end
  end
end
