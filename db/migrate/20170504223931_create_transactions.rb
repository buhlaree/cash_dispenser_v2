class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.text :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
    add_index :transactions, [:account_id, :created_at]
  end
end
