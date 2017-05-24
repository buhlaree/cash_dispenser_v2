class RemoveDepositFromTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :deposit, :boolean
  end
end
