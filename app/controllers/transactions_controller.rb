class TransactionsController < ApplicationController
  def new
    @user = current_user
    @options =  @user.accounts.all.collect do |account|
                ["Account Number " + "#{account.id}" + "  |  " +
                   "$#{account.total} available" , account.id]
                 end
  end

  def show
    @user = current_user
    @transaction = Transaction.find(params[:id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    Transaction.transaction do
      @transaction.save!
        if @transaction.deposit
          @transaction.account.update_attribute(:total,
                    @transaction.account.total.to_i + @transaction.amount.to_i)
        else
          @transaction.account.update_attribute(:total,
                    @transaction.account.total.to_i - @transaction.amount.to_i)
        end
    end
    redirect_to @transaction
  end

  private
    def transaction_params
      params.require(:transaction).permit(:amount, :account_id, :deposit)
    end
end
