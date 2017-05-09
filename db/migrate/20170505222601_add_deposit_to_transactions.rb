class AddDepositToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :deposit, :boolean
  end
end
