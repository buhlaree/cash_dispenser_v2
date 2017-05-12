class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :total
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :accounts, %i[user_id created_at]
  end
end
